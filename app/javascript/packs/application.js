// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

import Vue from 'vue'
import router from '../src/router'
import axios from 'axios'

window.addEventListener('load', () => {
  new Vue({
    router,

    el: '#vue-app',

    created() {
      let csrfToken = document.querySelector('meta[name="csrf-token"]')
      if (csrfToken)
        axios.defaults.headers.common['X-CSRF-Token'] = csrfToken.getAttribute('content')
    },

    render(h) {
      return h('router-view')
    }
  })
})
