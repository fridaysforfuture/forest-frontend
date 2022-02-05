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
          title="Der Titel, der über dem Linktree angezeigt wird"
        />
      </template>
      <b-input v-model="friendlyName" required />
    </b-field>
    <section class="field">
      <label class="label">
        <span class="has-text-weight-bold is-size-4"> Links: </span>
        <b-icon
          icon="information"
          type="is-info"
          custom-size="mdi-24px"
          title="Die Links des Linktrees, die 'Äste'"
        />
      </label>
      <div ref="linkContainer" style="position: relative">
        <div
          v-show="drag"
          id="drag"
          ref="drag"
          class="box columns is-centered is-vcentered"
        >
          <b-field horizontal custom-class="is-hidden" class="column link-data">
            <b-field label="Text" label-position="on-border">
              <b-input v-if="drag" v-model="drag.text" required />
            </b-field>
            <b-field label="URL" label-position="on-border">
              <b-input
                v-if="drag"
                v-model="drag.url"
                required
                type="url"
                oninvalid="this.setCustomValidity('URLs müssen mit https:// beginnen')"
                oninput="this.setCustomValidity('')"
              />
            </b-field>
            <b-button
              icon-right="delete"
              type="is-danger"
              expanded
              @click="removeLink(i)"
            />
          </b-field>
          <div
            class="column has-text-centered drag-drop-icon is-1"
            @mousedown="initDragAndDrop($event)"
            @touchstart="initDragAndDropTouch($event)"
          >
            <b-icon icon="drag" size="is-medium" type="is-grey" />
          </div>
        </div>
        <transition-group name="flip-list">
          <div
            v-for="(link, i) of links"
            :key="link.id"
            ref="linkList"
            class="box columns is-centered is-vcentered"
          >
            <b-field
              horizontal
              custom-class="is-hidden"
              class="column link-data"
            >
              <b-field label="Text" label-position="on-border">
                <b-input v-model="link.text" required />
              </b-field>
              <b-field label="URL" label-position="on-border">
                <b-input
                  v-model="link.url"
                  required
                  type="url"
                  oninvalid="this.setCustomValidity('URLs müssen mit https:// beginnen')"
                  oninput="this.setCustomValidity('')"
                />
              </b-field>
              <b-button
                icon-right="delete"
                type="is-danger"
                expanded
                @click="removeLink(i)"
              />
            </b-field>
            <div
              class="column has-text-centered drag-drop-icon is-1 is-hidden-mobile"
              @mousedown="initDragAndDrop($event)"
              @touchstart="initDragAndDropTouch($event)"
            >
              <b-icon icon="drag" size="is-medium" type="is-grey" />
            </div>
            <div class="is-hidden-tablet column is-1">
              <b-field grouped expanded>
                <b-field expanded>
                  <b-button
                    icon-left="chevron-double-down"
                    size="medium"
                    expanded
                    :disabled="i === links.length - 1"
                    @click="moveLinkDown(i)"
                  />
                </b-field>
                <b-field expanded>
                  <b-button
                    icon-left="chevron-double-up"
                    size="medium"
                    expanded
                    :disabled="i === 0"
                    @click="moveLinkUp(i)"
                  />
                </b-field>
              </b-field>
            </div>
          </div>
        </transition-group>
        <div class="placeholder"></div>
        <b-button expanded icon-right="plus" size="is-medium" @click="addLink">
        </b-button>
      </div>
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
          <b-input
            v-model="value.socialLinks[key]"
            type="url"
            oninvalid="this.setCustomValidity('URLs müssen mit https:// beginnen')"
            oninput="this.setCustomValidity('')"
          />
        </b-field>
      </b-field>
    </section>
    <div class="divider"></div>
    <section v-if="value && $auth.user.sub === value.owner" class="field pb-20">
      <label class="label">
        <span class="has-text-weight-bold is-size-4"> Geteilt mit: </span>
        <b-icon
          icon="information"
          type="is-info"
          custom-size="mdi-24px"
          title="Hier kannst du kontrollieren, wer noch den Linktree bearbeiten kann"
        />
      </label>
      <b-field
        v-for="(username, i) of sharedTo"
        :key="i"
        horizontal
        custom-class="is-hidden"
        class="box"
      >
        <b-field label="Username" label-position="on-border">
          <b-input v-model="sharedTo[i]" required />
        </b-field>
        <b-button
          icon-right="delete"
          type="is-danger"
          expanded
          @click="removeShare(i)"
        />
      </b-field>
      <b-button expanded icon-right="plus" size="is-medium" @click="addShare">
      </b-button>
    </section>
    <section v-else class="field pb-20">
      <label class="label">
        <span class="has-text-weight-bold is-size-4"> Tree Admin </span>
        <b-icon
          icon="information"
          type="is-info"
          custom-size="mdi-24px"
          title="Diese Person hat den Baum gepflanzt und kann einstellen wer Zugriff hat."
        />
      </label>
      <p v-if="value && value.owner">{{ value.owner }}</p>
    </section>
  </form>
</template>

<script lang="ts">
import { Vue, Component, Prop } from 'vue-property-decorator';

@Component({
  watch: {
    value(newValue) {
      for (const link of newValue.links) {
        if (!link.id) {
          const thisValue = this as TreeView;
          link.id = ++thisValue.lastId;
        }
      }
    },
  },
})
export default class TreeView extends Vue {
  @Prop(Object) value: any;
  @Prop(Boolean) disableNameEdit!: boolean;

  drag = null;

  get name() {
    return this.value?.name;
  }

  set name(newName) {
    if (this.value) {
      this.value.name = newName;
    }
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

  get sharedTo() {
    return this.value?.sharedTo;
  }

  set sharedTo(newSharedTo) {
    if (this.value.sharedTo) {
      this.value.sharedTo = newSharedTo;
    }
  }

  lastId = 0;

  addLink() {
    this.links.push({
      text: '',
      url: '',
      id: ++this.lastId,
    });
  }

  addShare() {
    this.value.sharedTo.push('');
  }

  removeLink(index: number) {
    this.links.splice(index, 1);
  }

  removeShare(index: number) {
    this.sharedTo.splice(index, 1);
  }

  initDragAndDropTouch(event: TouchEvent) {
    this.initDragAndDrop({
      ...(event.touches.item(0) as Touch),
      target: event.target as Element,
    });
  }

  initDragAndDrop(event: { pageX: number; pageY: number; target: Element }) {
    const realTarget =
      event.target!.parentElement!.parentElement!.parentElement!;
    const width = realTarget.offsetWidth + 'px';
    const linkList = this.$refs.linkList as HTMLElement[];
    const index = linkList
      .sort((a, b) => a.offsetTop - b.offsetTop)
      .findIndex((element) => element === realTarget);
    this.drag = this.links.splice(index, 1)[0];
    linkList.splice(index, 1);

    const drag = this.$refs.drag as HTMLElement;
    drag.style.width = width;

    const waypoints = linkList
      .map((element) => ({
        element: element as HTMLElement,
        y:
          document.documentElement.scrollTop +
          element.getBoundingClientRect().top,
      }))
      .sort((a, b) => b.y - a.y);

    let lastElement: any = null;
    let cachedMarginBottom: any = null;
    const linkContainer = this.$refs.linkContainer as HTMLElement;
    const containerRect = linkContainer.getBoundingClientRect();
    const containerTop = containerRect.top + document.documentElement.scrollTop;
    const containerHeight = containerRect.height;
    realTarget.style.display = 'none';
    const onMouseMove = (event: { pageX: number; pageY: number }) => {
      // Moving the dragged element
      const relativeScroll = event.pageY - containerTop;
      const boxedRelativeScroll = Math.min(
        Math.max(relativeScroll, 0),
        containerHeight,
      );
      const elementHeight = drag.getBoundingClientRect().height;
      drag.style.top = boxedRelativeScroll - elementHeight / 2 + 'px';

      // Creating the gap
      let hasFoundPlace = false;
      for (const entry of waypoints) {
        const rect = entry.element.getBoundingClientRect();
        if (
          event.pageY >
          rect.top + document.documentElement.scrollTop + rect.height / 2
        ) {
          if (lastElement !== entry.element) {
            linkContainer.style.paddingTop = '0';
            const oldMarginBottom = entry.element.style.marginBottom;
            entry.element.style.marginBottom = '116px';
            if (lastElement) {
              lastElement.style.marginBottom = cachedMarginBottom;
            }
            lastElement = entry.element;
            cachedMarginBottom = oldMarginBottom;
          }
          hasFoundPlace = true;
          break;
        }
      }
      if (!hasFoundPlace) {
        if (lastElement) {
          lastElement.style.marginBottom = cachedMarginBottom;
          lastElement = null;
        }
        linkContainer.style.paddingTop = 'calc(120px - 1rem)';
      }
    };
    onMouseMove(event);
    document.addEventListener('mousemove', onMouseMove);
    const onTouchMove = (event: TouchEvent) => {
      event.preventDefault();
      onMouseMove(event.touches.item(0)!);
    };
    document.addEventListener('touchmove', onTouchMove, { passive: false });

    const onMouseUp = (event: { pageY: number; pageX: number }) => {
      document.removeEventListener('mousemove', onMouseMove);
      document.removeEventListener('touchmove', onTouchMove);
      document.removeEventListener('mouseup', onMouseUp);
      let insertPosition = 0;
      for (let i = 0; i < waypoints.length; ++i) {
        const entry = waypoints[i];
        const rect = entry.element.getBoundingClientRect();
        if (
          event.pageY >
          rect.top + document.documentElement.scrollTop + rect.height / 2
        ) {
          insertPosition = waypoints.length - i;
          break;
        }
      }
      if (lastElement) {
        lastElement.style.marginBottom = cachedMarginBottom;
      }
      linkContainer.style.paddingTop = '';
      this.links.splice(insertPosition, 0, this.drag);
      this.drag = null;
    };
    const onTouchEnd = (event: TouchEvent) => {
      document.removeEventListener('touchend', onTouchEnd);
      onMouseUp(event.touches.item(0)!);
    };
    document.addEventListener('mouseup', onMouseUp);
    document.addEventListener('touchend', onTouchEnd);
  }

  moveLinkDown(i: number) {
    const removedLink = this.links.splice(i, 1);
    this.links.splice(i + 1, 0, removedLink[0]);
  }

  moveLinkUp(i: number) {
    const removedLink = this.links.splice(i, 1);
    this.links.splice(i - 1, 0, removedLink[0]);
  }
}
</script>
<style>
@media screen and (max-width: 768px) {
  .flip-list-move {
    transition: transform 1s;
  }
}
#drag {
  position: absolute;
  z-index: 1000;
}
.social-link {
  text-transform: capitalize;
}
.drag-drop-icon {
  padding: 0;
}
.link-data {
  margin: 0 !important;
}
.box {
  padding: 1rem;
}

.columns {
  margin-top: 0;
}

.placeholder {
  height: 60px;
}
.pb-20 {
  padding-bottom: 20px;
}
</style>
