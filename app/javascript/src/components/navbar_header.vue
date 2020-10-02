<template>
  <nav class="navbar navbar-expand-lg navbar-light bg-light mb-3">
    <div class="container">
      <router-link :to="{ name: 'VideosIndex' }" class="navbar-brand" style="font-size: 1.5rem">
        <i class="fa fa-tv mr-1"></i>
        SNLTube
      </router-link>

      <button class="navbar-toggler"
              type="button"
              data-toggle="collapse"
              data-target="#navbar-dropdown">
        <span class="navbar-toggler-icon"></span>
      </button>

      <div class="collapse navbar-collapse flex-row-reverse" id="navbar-dropdown">
        <ul class="navbar-nav">
          <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle" href="#" data-toggle="dropdown">
              <template v-if="loggedInAs">
                <i class="fa fa-user mr-1"></i>
                {{ loggedInAs }}
              </template>
              <template v-else>
                Visitor
              </template>
            </a>
            <ul class="dropdown-menu dropdown-menu-right">
              <li v-if="!loggedInAs">
                <router-link :to="{ name: 'SignIn' }" class="dropdown-item">
                  <i class="fa fa-sign-in-alt mr-2"></i>
                  Sign in
                </router-link>
              </li>
              <li v-else>
                <a @click.prevent="onLogout" class="dropdown-item" href="#">
                  <i class="fa fa-sign-out-alt mr-2"></i>
                  Sign out
                </a>
              </li>
            </ul>
          </li>
        </ul>
      </div>
    </div>
  </nav>
</template>

<script>
import axios from "axios"

export default {
  data() {
    return {
      loggedInAs: serverExports.loggedInAs
    }
  },

  methods: {
    onLogout() {
      if (confirm('Exit session?'))
        axios.delete('/api/sessions').then((response) => {
          window.location.reload()
        })
    }
  }
}
</script>
