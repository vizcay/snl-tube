import Vue from "vue"
import VueRouter from "vue-router"
import VideosIndex from "./pages/videos_index"
import SignIn from "./pages/sign_in"
import VideosShow from "./pages/videos_show"

Vue.use(VueRouter)

const router = new VueRouter({
  mode: 'history',

  routes: [
    {
      path: "/",
      name: "VideosIndex",
      component: VideosIndex
    },
    {
      path: "/sign_in",
      name: "SignIn",
      component: SignIn
    },
    {
      path: "/:id",
      name: "VideosShow",
      component: VideosShow
    }
  ]
})

export default router
