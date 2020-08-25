import Vue from 'vue';

declare module 'vue/types/vue' {
  interface Vue {
    $auth: any
    $buefy: any
  }
}
