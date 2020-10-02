<template>
  <div>
    <NavbarHeader />
    <div class="container">
      <div style="display: flex; justify-content: space-between; flex-wrap: wrap;">
        <div v-for="(video, index) in videos"
             :class="[`video-${index}`]"
             class="card mb-4"
             style="width: 24.5rem">
          <a @click.prevent="onShowVideo(video)" href="#">
            <img :src="video.thumbnail"
                 :alt="'Image ' + video.title"
                 style="width: 390px; height: 240px"
                 class="card-img-top">
          </a>
          <div class="card-body">
            <h5 class="card-title">
              <a @click.prevent="onShowVideo(video)"
                 href="#"
                 class="text-decoration-none text-dark">
                {{ video.title }}
                <br>
                <small>{{ video.published_at }}</small>
              </a>
              <span v-if="video.subscription_required"
                    class="badge bg-warning text-dark">
                <i class="fa fa-fire mr-1"></i>
                Premium
              </span>
            </h5>
          </div>
        </div>
      </div>

      <BootstrapPagination v-if="pagination"
                        :pagination="pagination"
                        @pageSwitch="onPageSwitch">
      </BootstrapPagination>
    </div>
  </div>
</template>

<script>
import axios from "axios"
import NavbarHeader from "../components/navbar_header"
import BootstrapPagination from "../components/bootstrap_pagination"

let videosPreview = new Array(9).fill({
  _id: 'preview',
  thumbnail: serverExports.videoPlaceholder,
  title: '.....'
})

export default {
  components: { NavbarHeader, BootstrapPagination },

  data() {
    return {
      videos: videosPreview,
      pagination: {},
      pendingRequest: false
    }
  },

  beforeRouteEnter(to, from, next) {
    next((vm) => {
      vm.pendingRequest = true
      axios.get('/api/videos.json', { params: { page: to.query.page }}).then((response) => {
        vm.videos = response.data.response
        vm.pagination = response.data.pagination
      }).finally(() => {
        vm.pendingRequest = false
      })
    })
  },

  beforeRouteUpdate(to, from, next) {
    this.videos = videosPreview
    this.pendingRequest = true
    axios.get('/api/videos.json', { params: { page: to.query.page }}).then((response) => {
      this.videos = response.data.response
      this.pagination = response.data.pagination
    }).finally(() => {
      this.pendingRequest = false
      next()
    })
  },

  methods: {
    onShowVideo(video) {
      if (video._id != 'preview')
        this.$router.push({ name: 'VideosShow', params: { id: video._id } })
    },

    onPageSwitch(page) {
      this.$router.push({ name: 'VideosIndex', query: { page } })
    }
  }
}
</script>
