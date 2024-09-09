import { apiInitializer } from "discourse/lib/api";

export default apiInitializer("1.8.0", (api) => {
  api.decorateCookedElement((cooked) => {
    const currentUser = api.getCurrentUser();

    if (!currentUser) {
      return;
    }

    const groupNames = currentUser.groups.map((group) => group.name);

    cooked.querySelectorAll("[data-wrap='mask']").forEach((mask) => {
      if (!groupNames.includes(mask.dataset.group)) {
        mask.remove();
      }
    });
  });
});
