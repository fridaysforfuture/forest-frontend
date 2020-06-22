<template>
  <form
    id="tree-view"
    class="container"
    @submit.prevent="$emit('submit', event)"
  >
    <b-field label="Name">
      <b-input v-model="name" required :disabled="disableNameEdit" />
    </b-field>
    <b-field label="Freundlicher Name">
      <b-input v-model="friendlyName" required />
    </b-field>
    <section class="field">
      <label class="label">
        Links:
      </label>
      <b-field
        v-for="(link, i) of links"
        :key="i"
        horizontal
        custom-class="is-hidden"
        class="box"
      >
        <b-field label="Text" label-position="on-border">
          <b-input v-model="link.text" required />
        </b-field>
        <b-field label="URL" label-position="on-border">
          <b-input v-model="link.url" required type="url" />
        </b-field>
        <b-button
          icon-right="delete"
          type="is-danger"
          expanded
          @click="removeLink(i)"
        />
      </b-field>
      <b-button expanded icon-right="plus" size="is-medium" @click="addLink">
      </b-button>
    </section>
  </form>
</template>
<style></style>
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

  removeLink(index: number) {
    this.links.splice(index, 1);
  }
}
</script>
