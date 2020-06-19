<template>
  <div>
    <b-navbar>
      <template slot="brand">
        <b-navbar-item tag="router-link" :to="{ name: 'index' }">
          <img src="~assets/buefy.png" alt="Forest" height=28 />
        </b-navbar-item>
      </template>
      <template slot="start">
        <b-navbar-item
          v-for="(item, key) of items" :key="key"
          tag="nuxt-link"
          :to="item.to">
          <b-icon :icon="item.icon" /> {{ item.title }}
        </b-navbar-item>
      </template>
    </b-navbar>

    <nuxt />
  </div>
</template>

<script>
export default {
  data() {
    return {
      items: [
        {
          title: 'Home',
          icon: 'home',
          to: { name: 'index' }
        },
        {
          title: 'My Forest',
          icon: 'tree',
          to: { path: '/user/forest' }
        }
      ]
    }
  }
}
</script>
