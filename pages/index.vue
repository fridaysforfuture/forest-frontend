<template>
  <section class="section">
    <b-button
      @click="login"
      v-if="!$auth.loggedIn">
      Login
    </b-button>
  </section>
</template>

<script lang=ts>
import { Vue, Component } from 'vue-property-decorator';

@Component
export default class IndexView extends Vue {
  login() {
    this.$auth.loginWith('oauth2').then(() => {console.log('test')});
  }

  created() {
    this.$axios.$get('http://localhost:3001/entries/abc');
  }
}
</script>
