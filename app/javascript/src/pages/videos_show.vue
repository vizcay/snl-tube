<template>
  <div>
    <NavbarHeader />
    <div class="container">
      <div v-if="forbiddenError" class="alert alert-danger text-center" role="alert">
        <i class="fa fa-credit-card fa-2x mb-2"></i> <br>
        A subscription must be purchased to watch premium content!
        <router-link :to="{ name: 'VideosIndex' }">
          Go back
        </router-link>
      </div>

      <div v-if="unexpectedError" class="alert alert-danger" role="alert">
        An unexpected error happened!
      </div>

      <iframe v-if="this.video.youtube_id"
              :src="youtubeURL"
              width="1280" height="720"
              frameborder="0"
              allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
              allowfullscreen></iframe>
      <h3>{{ video.title }}</h3>
    </div>
  </div>
</template>

<script>
import axios from "axios"
import NavbarHeader from "../components/navbar_header"

const
  UNAUTHORIZED = 401,
  FORBIDDEN    = 403

export default {
  components: { NavbarHeader },

  data() {
    return {
      video: {},
      pendingRequest: false,
      forbiddenError: false,
      unexpectedError: false
    }
  },

  created() {
    this.pendingRequest = true
    axios.get(`/api/videos/${this.$route.params.id}.json`).then((response) => {
      this.video = response.data
    }).catch((error) => {
      if (error.response.status == UNAUTHORIZED)
        this.$router.push({ name: 'SignIn', params: { premiumContent: true }})
      else if (error.response.status == FORBIDDEN)
        this.forbiddenError = true
      else
        this.unexpectedError = true
    }).finally(() => {
      this.pendingRequest = false
    })
  },

  computed: {
    youtubeURL() {
      return `https://www.youtube.com/embed/${this.video.youtube_id}`
    }
  }
}
</script>
