<template>
  <form class="container">
    <b-field label="Name">
      <b-input v-model="name" required :disabled="disableNameEdit" />
    </b-field>
    <b-field label="Freundlicher Name">
      <b-input v-model="friendlyName" required />
    </b-field>
    <section class="section">
      <label>
        Links:
      </label>
      <b-field v-for="(link, i) of links" :key="i">
        <b-field label="Text">
          <b-input v-model="link.text" />
        </b-field>
        <b-field label="URL">
          <b-input v-model="link.url" />
        </b-field>
      </b-field>
      <b-button @click="addLink">
        Neuer Link
      </b-button>
    </section>
  </form>
</template>

<script lang="ts">
import { Vue, Component, Prop } from 'vue-property-decorator';

@Component
export default class TreeView extends Vue {
  @Prop(Object) value!: any;
  @Prop(Boolean) disableNameEdit!: boolean;

  get name() {
    return this.value.name;
  }

  set name(newName) {
    this.value.name = newName;
  }

  get friendlyName() {
    return this.value.friendlyName;
  }

  set friendlyName(newFriendlyName) {
    this.value.friendlyName = newFriendlyName;
  }

  get links() {
    return this.value.links;
  }

  set links(newLinks) {
    this.value.links = newLinks;
  }

  addLink() {
    this.links.push({
      text: '',
      url: '',
    });
  }
}
</script>
