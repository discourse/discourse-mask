import { apiInitializer } from "discourse/lib/api";
import ToggleMask from "../components/toggle-mask";

/*
 * This is a simple example of how too much power can be dangerous.
 */

const processMask = (currentUser, mask, groupNames, helper) => {
  // prevents multiple runs
  if (mask.dataset.computed) {
    return;
  }

  const div = document.createElement("div");
  mask.insertAdjacentElement("afterbegin", div);

  helper.renderGlimmer(
    div,
    <template><ToggleMask @mask={{@data.mask}} /></template>,
    {
      mask,
    }
  );

  mask.dataset.computed = true;
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
      processMask(currentUser, mask, groupNames, helper);
    });
  });
});
