<template>
  <form
    @submit.prevent="submit">
    <b-field
      label="Name">
      <b-input
        v-model="name"
        required />
    </b-field>
    <b-field label="Freundlicher Name">
      <b-input
        v-model="friendlyName"
        required />
    </b-field>
    <section class="section">
      <label>
        Links:
      </label>
      <b-field v-for="link of links">
        <b-field label="Text">
          <b-input
            v-model="link.text"/>
        </b-field>
        <b-field label="URL">
          <b-input
            v-model="link.url"/>
        </b-field>
      </b-field>
      <b-button
        @click="addLink">
        Neuer Link
      </b-button>
    </section>
    <b-button native-type="submit">
      Eintrag erstellen
    </b-button>
  </form>
</template>

<script lang="ts">
import { Vue, Component, Prop } from 'vue-class-decorator';
import axios from 'axios';

@Component 
export default class CreateView extends Vue {
  name = '';
  friendlyName = '';
  links = [{
    text: '',
    url: ''
  }];

  addLink() {
    this.links.push({
      text: '',
      url: ''
    });
  }

  submit() {
    axios.put(`http://localhost:3001/entries/${this.name}`,
      {
        friendlyName: this.friendlyName,
        links: this.links
      });
  }
}
</script>
