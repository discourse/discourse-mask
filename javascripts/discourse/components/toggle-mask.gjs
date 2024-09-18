import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { on } from "@ember/modifier";
import { action } from "@ember/object";
import didInsert from "@ember/render-modifiers/modifiers/did-insert";
import { service } from "@ember/service";
import DToggleSwitch from "discourse/components/d-toggle-switch";

export default class ToggleMask extends Component {
  @service currentUser;

  @tracked showMyActivities = true;

  groupNames = this.currentUser.groups.map((group) => group.name);

  @action
  handleToggle() {
    this.showMyActivities = !this.showMyActivities;
    this.applyMask();
  }

  @action
  applyMask() {
    const table = this.args.mask.querySelector("table");

    if (!table) {
      return;
    }

    const rows = table.querySelectorAll("tbody tr");

    rows.forEach((row) => {
      if (!this.showMyActivities) {
        row.classList.remove("hidden");
        return;
      }

      const lastCell = row
        .querySelector("td:last-child")
        .textContent.toLowerCase();
      if (
        !lastCell
          .split(",")
          .filter(Boolean)
          .includes(this.currentUser.username_lower) &&
        lastCell !== "" &&
        lastCell !== "all" &&
        !this.groupNames.includes(lastCell)
      ) {
        row.classList.add("hidden");
      }
    });
  }

  <template>
    <div class="my-activityes-toggle">
      <DToggleSwitch
        @state={{this.showMyActivities}}
        {{on "click" this.handleToggle}}
        {{didInsert this.applyMask}}
      />
      <span>Show only my activities</span>
    </div>
  </template>
}
