<template>
  <nav aria-label="Page navigation example">
    <ul class="pagination justify-content-end">
      <li v-if="pagination.current > 1" class="page-item">
        <a @click.prevent="onPageSwitch(pagination.current - 1)"
          class="page-link"
          href="#">
          <i class="fa fa-angle-left fa-lg"></i>
        </a>
      </li>
      <li v-for="page in visiblePages"
          :class="{ active: page == pagination.current }"
          class="page-item">
        <span v-if="page == pagination.current" class="page-link">
          {{ page }}
          <span class="sr-only">(current)</span>
        </span>
        <a v-else
           @click.prevent="onPageSwitch(page)"
           class="page-link" href="#">
          {{ page }}
        </a>
      </li>
      <li v-if="pagination.current < pagination.pages" class="page-item">
        <a @click.prevent="onPageSwitch(pagination.current + 1)"
           class="page-link"
           href="#">
          <i class="fa fa-angle-right fa-lg"></i>
        </a>
      </li>
    </ul>
  </nav>
</template>

<script>
export default {
  props: {
    pagination: {
      type: Object,
      required: true
    }
  },
  methods: {
    onPageSwitch(page) {
      this.pagination.current = page
      this.$emit('pageSwitch', page)
    }
  },

  computed: {
    startPage() {
      return Math.max(this.pagination.current - 3, 1)
    },

    endPage() {
      return Math.min(this.pagination.current + 3, this.pagination.pages)
    },

    visiblePages() {
      if (this.pagination.current)
        return Array(this.endPage - this.startPage + 1).fill(this.startPage).map((base, i) => base + i)
      else
        return []
    }
  }
}
</script>
