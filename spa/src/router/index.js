import api from '../api'
import Vue from 'vue'
import Router from 'vue-router'
import EntityView from '@/components/EntityForm'
import LoginView from '@/components/Login'
import NewEntityView from '@/components/NewEntityForm'
import TableView from '@/components/EntityTable'

Vue.use(Router)

let router = new Router({
  routes: [
    { path: '/', redirect: '/tabelle/base/1' },
    { path: '/login',
      component: LoginView,
      props (route) {
        return {path: route.query.path}
      }
    },
    { path: '/tabelle/:discriminator', redirect: '/tabelle/:discriminator/1' },
    {
      path: '/tabelle/:discriminator/:find/:page',
      component: TableView,
      props: function (route) {
        return { page: parseInt(route.params.page), find: route.params.find, discriminator: route.params.discriminator }
      }
    },
    {
      path: '/tabelle/:discriminator/:page',
      component: TableView,
      props: function (route) {
        return { page: parseInt(route.params.page), discriminator: route.params.discriminator }
      }
    },
    {
      path: '/neu/:discriminator/:prefix',
      component: NewEntityView,
      props (route) {
        return {
          id: null,
          discriminator: route.params.discriminator,
          prefix: route.params.prefix
        }
      }
    },
    {
      path: '/detail/:discriminator/:id',
      component: EntityView,
      props (route) {
        let id = parseInt(route.params.id)
        return {
          id: isNaN(id) ? null : id,
          discriminator: route.params.discriminator
        }
      }
    }
  ]
})

router.beforeEach((to, from, next) => {
  if (to.path.startsWith('/login') || (api.getUsername() && api.getExpires() > new Date())) {
    next()
  } else {
    next({path: '/login?path=' + encodeURIComponent(to.path), replace: from.path === '/'})
  }
})

export default router
