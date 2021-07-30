<template>
  <div>
    <b-navbar>
      <template slot="brand">
        <b-navbar-item tag="router-link" :to="{ name: 'index' }">
          <img src="forest2.svg" alt="Forest" height="28" />
        </b-navbar-item>
      </template>
      <template slot="end">
        <b-navbar-item v-if="$auth.loggedIn" tag="div">
          <div>
            Eingeloggt als
            <span class="has-text-weight-semibold">{{ $auth.user.sub }}</span>
          </div>
        </b-navbar-item>
        <b-navbar-item tag="div">
          <div v-if="!$auth.loggedIn" class="buttons">
            <b-button @click="login"> Login </b-button>
          </div>
          <div v-else class="buttons">
            <b-button @click="logout"> Logout </b-button>
          </div>
        </b-navbar-item>
      </template>
    </b-navbar>

    <nuxt />
  </div>
</template>

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

<style>
.navbar-item {
  margin: 0;
}
</style>
