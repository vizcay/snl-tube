<template>
  <div>
    <NavbarHeader />
    <div class="container">
      <div class="p-4 bg-light border rounded-sm mx-auto mt-5" style="width: 25rem">
        <div class="text-center mb-3">
          <i class="fa fa-key fa-2x"></i> <br>
        </div>

        <div v-if="$route.params.premiumContent" class="alert alert-primary text-center">
          This is premium content! <br>
          Please sign in to continue..
        </div>

        <form>
          <p v-if="unauthorized" class="text-danger text-center">
            <i class="fa fa-exclamation-triangle mr-1"></i>
            Invalid username or password.
          </p>

          <p v-if="unknownError" class="text-danger text-center">
            <i class="fa fa-exclamation-triangle mr-1"></i>
            An unexpected error has happened, please try again.
          </p>

          <div class="mb-3">
            <label for="email" class="form-label">Email:</label>
            <input v-model="email" type="email" class="form-control" id="email">
          </div>

          <div class="mb-3">
            <label for="password" class="form-label">Password:</label>
            <input v-model="password" type="password" class="form-control" id="password">
          </div>

          <div class="text-center mt-4">
            <button @click.prevent="onLogin"
                    :disabled="pendingRequest"
                    type="submit"
                    class="btn btn-primary">
              <i v-if="!pendingRequest" class="fa fa-sign-in-alt fa-fw mr-2"></i>
              <i v-else class="fa fa-spin fa-spinner fa-fw mr-2"></i>
              Sign in
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios"
import NavbarHeader from "../components/navbar_header"

export default {
  components: { NavbarHeader },

  data() {
    return {
      email: '',
      password: '',
      pendingRequest: false,
      unauthorized: false,
      unknownError: false
    }
  },

  methods: {
    onLogin() {
      this.resetRequest()
      axios.post('/api/sessions', { email: this.email, password: this.password }).then((response) => {
        serverExports.loggedInAs = this.email
        this.$router.go(-1)
      }).catch((error) => {
        if (error.response.status == 401)
          this.unauthorized = true
        else
          this.unknownError = true
        this.password = ''
      }).finally(() =>
        this.pendingRequest = false
      )
    },

    resetRequest() {
      this.pendingRequest = false
      this.unauthorized   = false
      this.unknownError   = false
    }
  }
}
</script>
