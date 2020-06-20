<template>
  <section class="section">
    <b-button v-if="!$auth.loggedIn" @click="login">
      Login
    </b-button>
  </section>
</template>

<script lang="ts">
import { Vue, Component } from 'vue-property-decorator';

@Component
export default class IndexView extends Vue {
  login() {
    this.$auth.loginWith('oauth2');
  }

  created() {
    this.$axios.$get('http://localhost:3001/entries/abc');
  }
}
</script>
