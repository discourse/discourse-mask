import Service, { service } from "@ember/service";

export default class Masker extends Service {
  @service currentUser;

  groupNames = this.currentUser.groups.map((group) => group.name);

  toggleTable({ table, shouldShowActivities }) {
    const rows = table.querySelectorAll("tbody tr");
    for (const row of rows) {
      if (!shouldShowActivities) {
        row.classList.remove("hidden");
        continue;
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
    }
  }

  toggleChecklist({ checklist, shouldShowAllTodos }) {
    const todos = checklist.querySelectorAll("li.has-checkbox");
    let doneCount = 0;
    for (const todo of todos) {
      if (!shouldShowAllTodos) {
        todo.classList.remove("hidden");
        continue;
      }
      const checkbox = todo.querySelector("span");

      if (checkbox.classList.contains("checked")) {
        doneCount = doneCount + 1;
        todo.classList.add("hidden");
      }
    }

    if (!checklist.querySelector("#done-text")) {
      const doneText = document.createElement("span");
      doneText.setAttribute("id", "done-text");
      checklist.appendChild(doneText);
    }

    checklist.querySelector("#done-text").textContent =
      doneCount === todos.length ? "All done!" : "";
  }
}
