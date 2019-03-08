// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import router from './router'
import BootstrapVue from 'bootstrap-vue'

Vue.use(BootstrapVue)
Vue.config.productionTip = false

Vue.filter('capitalize', function (s) {
  return s && s[0].toUpperCase() + s.slice(1)
})
Vue.filter('friendlyDate', function (s) {
  return s.slice(0, s.indexOf('T'))
})
Vue.filter('friendlyTime', function (s) {
  return s.slice(s.indexOf('T') + 1, s.indexOf('.'))
})

new Vue({
  router,
  render: h => h(App)
}).$mount('#app')
