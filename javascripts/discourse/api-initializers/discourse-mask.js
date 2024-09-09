import { apiInitializer } from "discourse/lib/api";

/*
 * This is a simple exmample of how too much power can be dangerous.
 */

let showEverything = false;

const applyMask = (cooked, groupNames) => {
  const table = cooked.querySelector("table");

  if (!table) {
    return;
  }

  const rows = table.querySelectorAll("tbody tr");

  rows.forEach((row) => {
    if (showEverything) {
      row.classList.remove("hidden");
      return;
    }

    const lastCell = row.querySelector("td:last-child").textContent;
    if (
      lastCell !== "" &&
      lastCell !== "all" &&
      !groupNames.includes(lastCell)
    ) {
      row.classList.add("hidden");
    }
  });
};

const processMask = (currentUser, mask, groupNames) => {
  // prevents multiple runs
  if (mask.dataset.computed) {
    applyMask(mask, groupNames);
    return;
  }

  const allButton = document.createElement("button");
  allButton.textContent = "All events";
  allButton.classList.add("btn", "btn-primary", "all-events-button");
  allButton.onclick = () => {
    showEverything = true;
    applyMask(mask, groupNames);
  };
  mask.insertAdjacentElement("afterbegin", allButton);

  const mineButton = document.createElement("button");
  mineButton.textContent = "My events";
  mineButton.classList.add("btn", "btn-primary", "mine-events-button");
  mineButton.onclick = () => {
    showEverything = false;
    applyMask(mask, groupNames);
  };
  mask.insertAdjacentElement("afterbegin", mineButton);

  mask.dataset.computed = true;

  applyMask(mask, groupNames);
};

export default apiInitializer("1.8.0", (api) => {
  api.decorateCookedElement((cooked, helper) => {
    if (!helper) {
      return;
    }

    const currentUser = api.getCurrentUser();
    if (!currentUser) {
      return;
    }

    const masks = cooked.querySelectorAll(".d-wrap[data-wrap='mask']");
    if (!masks.length) {
      return;
    }

    const groupNames = currentUser.groups.map((group) => group.name);

    masks.forEach((mask) => {
      processMask(currentUser, mask, groupNames);
    });
  });
});
