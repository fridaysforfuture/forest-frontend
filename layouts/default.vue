<template>
  <div>
    <b-navbar>
      <template slot="brand">
        <b-navbar-item tag="router-link" :to="{ name: 'index' }">
          <img src="forest2.svg" alt="Forest" height="28" />
        </b-navbar-item>
      </template>
      <template slot="end">
        <b-navbar-item tag="div">
          <div class="buttons">
            <b-button v-if="!$auth.loggedIn" @click="login">
              Login
            </b-button>
            <b-button v-else @click="logout">
              Logout
            </b-button>
          </div>
        </b-navbar-item>
      </template>
    </b-navbar>

    <nuxt />
  </div>
</template>

<style>
.navbar-item {
  margin: 0;
}
</style>

<script lang="ts">
import { Vue, Component } from 'vue-property-decorator';

@Component
export default class LayoutComponent extends Vue {
  login() {
    this.$auth.loginWith('oauth2');
  }

  logout() {
    this.$auth.logout();
  }
}
</script>
