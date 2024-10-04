import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { on } from "@ember/modifier";
import { action } from "@ember/object";
import didInsert from "@ember/render-modifiers/modifiers/did-insert";
import { service } from "@ember/service";
import DToggleSwitch from "discourse/components/d-toggle-switch";

export default class ToggleMask extends Component {
  @service masker;
  @tracked showMyActivities = true;
  @tracked displayText = "";

  @action
  handleToggle() {
    this.showMyActivities = !this.showMyActivities;
    this.applyMask();
  }

  @action
  applyMask() {
    const table = this.args.mask.querySelector("table");
    if (table) {
      this.displayText = "Show only my activities";
      return this.masker.toggleTable({
        table,
        shouldShowActivities: this.showMyActivities,
      });
    }

    const checklist = this.args.mask.querySelector("ul"); // maybe there is a better way to get checklists
    if (checklist) {
      this.displayText = "Show what is left to be done";
      return this.masker.toggleChecklist({
        checklist,
        shouldShowAllTodos: this.showMyActivities,
      });
    }

    console.error("[discourse-mask]: This mask does not exist, check your MD");
  }

  <template>
    <div class="my-activityes-toggle">
      <DToggleSwitch
        @state={{this.showMyActivities}}
        {{on "click" this.handleToggle}}
        {{didInsert this.applyMask}}
      />
      <span>{{this.displayText}}</span>
    </div>
  </template>
}
