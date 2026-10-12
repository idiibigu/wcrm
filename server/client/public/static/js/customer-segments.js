(() => {
  if (window.location.pathname === "/customer-segments.html") return;

  const shortcutId = "wcrm-customer-segments-shortcut";

  function updateShortcut() {
    const onPhonebook =
      window.location.pathname === "/user" &&
      new URLSearchParams(window.location.search).get("page") === "phonebook";
    const existing = document.getElementById(shortcutId);
    if (!onPhonebook) {
      existing?.remove();
      return;
    }
    if (existing) return;

    const heading = [...document.querySelectorAll("h5")].find(
      (element) => element.textContent.trim() === "Phonebook",
    );
    const actions = heading?.parentElement?.parentElement;
    if (!actions) return;

    const link = document.createElement("a");
    link.id = shortcutId;
    link.className = "segments-shortcut";
    link.href = "/customer-segments.html";
    link.textContent = "Customer Segments · شرائح العملاء";
    link.setAttribute("aria-label", "Customer segments, شرائح العملاء");
    actions.append(link);
  }

  const originalPushState = history.pushState;
  history.pushState = function (...args) {
    const result = originalPushState.apply(this, args);
    updateShortcut();
    return result;
  };
  window.addEventListener("popstate", updateShortcut);
  new MutationObserver(updateShortcut).observe(document.documentElement, {
    childList: true,
    subtree: true,
  });
  updateShortcut();
})();
