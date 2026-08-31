// Storefront chrome behaviour: mobile nav drawer + cart button delegation.
//
// Uses document-level delegation so the handlers survive LiveView DOM patches
// without needing a hook on every button.

function menuEls() {
  return {
    panel: document.getElementById("store-menu-panel"),
    backdrop: document.getElementById("store-menu-backdrop"),
  };
}

window.openStoreMenu = function openStoreMenu() {
  const { panel, backdrop } = menuEls();
  if (!panel || !backdrop) return;
  panel.style.transform = "translateX(0)";
  backdrop.style.opacity = "1";
  backdrop.style.pointerEvents = "auto";
  document.body.style.overflow = "hidden";
};

window.closeStoreMenu = function closeStoreMenu() {
  const { panel, backdrop } = menuEls();
  if (!panel || !backdrop) return;
  panel.style.transform = "translateX(-100%)";
  backdrop.style.opacity = "0";
  backdrop.style.pointerEvents = "none";
  document.body.style.overflow = "";
};

// Close the drawer when navigating away or pressing Escape.
window.addEventListener("phx:page-loading-stop", () => window.closeStoreMenu());
window.addEventListener("keydown", (e) => {
  if (e.key === "Escape") window.closeStoreMenu();
});

// Cart buttons: open the slide-over, except on /cart and /checkout where the
// drawer is suppressed — there we just go to the cart page.
const CART_TRIGGERS = ["#open-cart-drawer", "#open-cart-drawer-floating"];

document.addEventListener("click", (e) => {
  const trigger = CART_TRIGGERS.map((sel) => e.target.closest(sel)).find(Boolean);
  if (!trigger) return;

  e.preventDefault();

  const onCartPage =
    window.location.pathname === "/cart" || window.location.pathname === "/checkout";

  if (onCartPage || !window.CartDrawer) {
    window.location.href = "/cart";
  } else {
    window.CartDrawer.open();
  }
});

// Simple tab switcher used by the product page and the tabbed product grid.
// Buttons carry data-tab-group / data-tab-target; panels carry data-tab-panel.
document.addEventListener("click", (e) => {
  const btn = e.target.closest("[data-tab-target]");
  if (!btn) return;

  const group = btn.dataset.tabGroup;
  const target = btn.dataset.tabTarget;
  if (!group || !target) return;

  document.querySelectorAll(`[data-tab-group="${group}"][data-tab-target]`).forEach((el) => {
    el.dataset.tabActive = el.dataset.tabTarget === target ? "true" : "false";
  });

  document.querySelectorAll(`[data-tab-panel][data-tab-group="${group}"]`).forEach((el) => {
    el.classList.toggle("hidden", el.dataset.tabPanel !== target);
  });
});
