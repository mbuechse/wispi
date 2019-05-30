import axios from 'axios'

let blubb = axios.create({
  // baseURL: 'http://192.168.1.39:3000/',
  // // baseURL: 'http://localhost:3000/',
  baseURL: 'https://bundd.uber.space/wispi_db/',
  headers: {}
})

let credentials = {}

const DiscriminatorKombi = [
  // X-ist-Y-von-Z, hier als Y, Z, X
  ['ist_mitglied', 'organisation', 'person'],
  ['ist_personkontakt', 'person', 'person'],
  // ['filmautorin', 'film', 'person'],
  // ['regisseurin', 'film', 'person'],
  ['ist_autorin', 'ressource', 'person'],
  ['ist_organisationkontakt', 'organisation', 'person'],
  ['ist_thema', 'base', 'thema'],
  ['ist_raumkontakt', 'raum', 'person'],
  ['ist_raumorganisation', 'raum', 'organisation'],
  ['ist_aktionaktive', 'aktion', 'person'],
  ['ist_aktionsraum', 'aktion', 'raum'],
  ['ist_aktionsinventar', 'aktion', 'inventar'],
  ['ist_aktionspartnerorga', 'aktion', 'organisation'],
  ['ist_unterorganisation', 'organisation', 'organisation']
]

const RelationFields = ['subjekt_id', 'objekt_id']

const DiscriminatorFieldTable = {
  base: ['url', 'bemerkungen'],
  person: ['name', 'vorname', 'titel', 'anrede', 'funktion', 'kontaktaufnahme', 'ansprache'],
  referentin: ['honorar'],
  organisation: ['name'],
  raum: ['name', 'lage', 'groesse_qm', 'personenzahl', 'verwaltung', 'kosten'],
  aktion: ['name', 'rahmenveranstaltung', 'zeitraum', 'turnus', 'fristen'],
  inventar: ['bezeichnung', 'lagerung', 'anschaffung', 'zustaendig'],
  ressource: ['titel', 'zielgruppe', 'erstellungsdatum'],
  thema: ['thema'],
  ist_mitglied: RelationFields,
  ist_personkontakt: RelationFields,
  ist_organisationkontakt: RelationFields,
  ist_thema: RelationFields
}

const DisciminatorSpecificsTable = {
  person: ['referentin']
}

function copyData (discriminator, data) {
  var d = {}
  DiscriminatorFieldTable[discriminator].forEach(x => { d[x] = data[x] })
  if (data.id) {
    d.id = data.id
  }
  return d
}

const api = {
  DiscriminatorKombi,

  login (username, password) {
    delete blubb.defaults.headers['Authorization']
    return blubb.post('rpc/login', {email: username, pass: password})
      .then(response => {
        let token = response.data[0].token
        let payload = JSON.parse(atob(token.split('.')[1]))
        credentials.username = payload.email
        credentials.role = payload.role
        credentials.expires = new Date(payload.exp * 1000)
        credentials.token = token
        blubb.defaults.headers['Authorization'] = 'Bearer ' + token
      }).catch(err => { throw Error(err.response.data.message) })
  },

  getUsername () {
    return credentials.username
  },

  getExpires () {
    return credentials.expires
  },

  updateGeneric (data) {
    let discriminator = data.discriminator
    let specifics = DisciminatorSpecificsTable[discriminator] || []
    let id = data.id
    return new Promise(function (resolve, reject) {
      Promise.all([
        blubb.patch('base?id=eq.' + encodeURIComponent(id), copyData('base', data)),
        blubb.patch(discriminator + '?id=eq.' + encodeURIComponent(data.id), copyData(discriminator, data))
      ].concat(specifics.map(specific => {
        let specificData = data[specific]
        let previousId = data[specific + 'Id']
        if (specificData.checked && previousId !== null) {
          return blubb.patch(specific + '?id=eq.' + encodeURIComponent(id), copyData(specific, specificData))
        } else if (specificData.checked) {
          let d = copyData(specific, specificData)
          d.id = id
          return blubb.post(specific, d)
        } else if (previousId !== null) {
          return blubb.delete(specific + '?id=eq.' + encodeURIComponent(id))
        }
      })))
        .then(response => resolve(id))
        .catch(reject)
    })
  },

  insertGeneric (data) {
    let specifics = DisciminatorSpecificsTable[data.discriminator] || []
    return new Promise(function (resolve, reject) {
      blubb.post('base', {...copyData('base', data), 'discriminator': data.discriminator}, {
        headers: {'Prefer': 'return=representation'}
      })
        .then(response => {
          let id = response.data[0].id
          data.id = id
          Promise.all([blubb.post(data.discriminator, copyData(data.discriminator, data))].concat(specifics.map(specific => {
            if (data[specific].checked) {
              let d = copyData(specific, data[specific])
              d.id = id
              return blubb.post(specific, d)
            }
          }))).then(x => resolve(id)).catch(reject)
        })
        .catch(reject)
    })
  },

  makeGeneric (discriminator, prefix) {
    var data = {discriminator}
    let specifics = DisciminatorSpecificsTable[discriminator] || []
    specifics.forEach(specific => {
      data[specific] = {checked: false}
      data[specific + 'Id'] = null
    })
    let prefixField = DiscriminatorFieldTable[discriminator][0]
    if (prefix && !prefixField.endsWith('_id')) {
      data[prefixField] = prefix
    }
    return data
  },

  removeGeneric (id) {
    return new Promise(function (resolve, reject) {
      blubb.delete('base?id=eq.' + encodeURIComponent(id))
      .then(response => resolve(null)).catch(reject)
    })
  },

  getGeneric (discriminator, query, limit) {
    return new Promise(function (resolve, reject) {
      let url = discriminator + '_view?select=*'
      if (query) {
        url += '&friendly=ilike.' + encodeURIComponent('*' + query + '*')
      }
      if (limit) {
        url += '&limit=' + encodeURIComponent(limit)
      }
      blubb.get(url)
        .then(response => resolve(response.data))
        .catch(reject)
    })
  },

  getGenericDetail (discriminator, id) {
    const table = discriminator.startsWith('ist_') ? 'ist_relation' : discriminator
    let specifics = DisciminatorSpecificsTable[discriminator] || []
    return Promise.all([
      blubb.get(table + '_view?select=*&id=eq.' + encodeURIComponent(id))
    ].concat(specifics.map(specific => blubb.get(specific + '?select=*&id=eq.' + encodeURIComponent(id)))))
    .then(responseArray => {
      if (responseArray[0].data.length !== 1) {
        throw new Error('Not found')
      }
      var data = responseArray[0].data[0]
      var i
      for (i = 0; i < specifics.length; i++) {
        if (responseArray[1 + i].data.length > 0) {
          let specificData = responseArray[1 + i].data[0]
          data[specifics[i]] = specificData
          data[specifics[i]].checked = true
          data[specifics[i] + 'Id'] = specificData.id
        } else {
          data[specifics[i]] = {checked: false}
          data[specifics[i] + 'Id'] = null
        }
      }
      return data
    })
  },

  insertIstRel (discriminator, subjektId, objektId) {
    return new Promise(function (resolve, reject) {
      blubb.post('rpc/insert_' + discriminator, {subjekt_id: subjektId, objekt_id: objektId})
      .then(resolve).catch(reject)
    })
  },

  getBeteiligung (baseId) {
    return new Promise(function (resolve, reject) {
      var encoded = encodeURIComponent(baseId)
      blubb.get('ist_relation_view?select=*&or=(subjekt_id.eq.' + encoded + ',objekt_id.eq.' + encoded + ')&order=discriminator,subjekt_friendly,objekt_friendly')
      .then(response => resolve(response.data)).catch(reject)
    })
  },

  getExtra (extra, id) {
    return new Promise(function (resolve, reject) {
      blubb.get(extra + '?id=eq.' + encodeURIComponent(id))
      .then(response => {
        if (response.data.length !== 1) {
          reject(new Error(extra + ' ' + String(id) + ' existiert nicht'))
        }
        resolve(response.data[0])
      }).catch(reject)
    })
  },

  getExtraFor (extra, baseId) {
    return new Promise(function (resolve, reject) {
      blubb.get(extra + '?select=*&base_id=eq.' + encodeURIComponent(baseId))
      .then(response => resolve(response.data)).catch(reject)
    })
  },

  patchExtra (extra, data) {
    return new Promise(function (resolve, reject) {
      blubb.patch(extra + '?id=eq.' + encodeURIComponent(data.id), data)
      .then(response => resolve(null)).catch(reject)
    })
  },

  postExtra (extra, data) {
    return new Promise(function (resolve, reject) {
      blubb.post(extra, data, {
        headers: {'Prefer': 'return=representation'}
      })
      .then(response => {
        let id = response.data[0].id
        data.id = id
        resolve(id)
      }).catch(reject)
    })
  },

  removeExtra (extra, id) {
    return new Promise(function (resolve, reject) {
      blubb.delete(extra + '?id=eq.' + encodeURIComponent(id))
      .then(response => resolve(null)).catch(reject)
    })
  }

}

export default api
