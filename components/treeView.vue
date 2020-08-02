<template>
  <form
    id="tree-view"
    class="container"
    @submit.prevent="$emit('submit', event)"
  >
    <b-loading :active="!value"> </b-loading>
    <b-field>
      <template slot="label" class="has-text-weight-bold">
        <span class="has-text-weight-bold is-size-4"> Name: </span>
        <b-icon
          icon="information"
          type="is-info"
          custom-size="mdi-24px"
          title="Der Link unter dem der Linktree erreichbar ist"
        />
      </template>
      <b-input v-model="name" required :disabled="disableNameEdit" />
    </b-field>
    <b-field>
      <template slot="label" class="has-text-weight-bold">
        <span class="has-text-weight-bold is-size-4"> Anzeigename: </span>
        <b-icon
          icon="information"
          type="is-info"
          custom-size="mdi-24px"
          title="Der Titel, der über dem Linktree angzeigt wird"
        />
      </template>
      <b-input v-model="friendlyName" required />
    </b-field>
    <section class="field">
      <label class="label">
        <span class="has-text-weight-bold is-size-4">
          Links:
        </span>
        <b-icon
          icon="information"
          type="is-info"
          custom-size="mdi-24px"
          title="Die Links des Linktrees, die 'Äste'"
        />
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
    <section
      v-if="value && Object.keys(value.socialLinks).length > 0"
      class="field"
    >
      <label class="label is-size-4 has-text-weight-bold">
        Social-Media-Links:
        <b-icon
          icon="information"
          type="is-info"
          custom-size="mdi-24px"
          title="Die Social-Media-Links, die unter dem Linktree angezeigt werden."
        />
      </label>
      <b-field v-for="(_, key) in value.socialLinks" :key="key">
        <b-field :label="key + ':'" horizontal class="social-link">
          <b-input v-model="value.socialLinks[key]" type="url" />
        </b-field>
      </b-field>
    </section>
  </form>
</template>
<style>
.social-link {
  text-transform: capitalize;
}
</style>
<script lang="ts">
import { Vue, Component, Prop } from 'vue-property-decorator';

@Component
export default class TreeView extends Vue {
  @Prop(Object) value: any;
  @Prop(Boolean) disableNameEdit!: boolean;

  get name() {
    return this.value?.name;
  }

  set name(newName) {
    this.value?.name = newName;
  }

  get friendlyName() {
    return this.value?.friendlyName;
  }

  set friendlyName(newFriendlyName) {
    if (this.value) {
      this.value.friendlyName = newFriendlyName;
    }
  }

  get links() {
    return this.value?.links;
  }

  set links(newLinks) {
    if (this.value) {
      this.value.links = newLinks;
    }
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
