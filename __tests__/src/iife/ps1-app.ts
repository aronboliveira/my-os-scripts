/**
 * PowerShell Aliases Reference — Interactive Module
 * Extracted from PowerShell/ps1/aliases-references.html <script> element.
 * Wrapped in IIFE for production; exported for testing.
 */

// eslint-disable-next-line @typescript-eslint/no-namespace
namespace Ps1App {
  const SCROLL_THRESHOLD = 60;
  const NAV_HIDE_DELAY = 2500;
  const TYPING_SPEED = 45;
  const OUTPUT_DELAY = 400;
  const RESTART_DELAY = 3000;
  const PASSIVE: AddEventListenerOptions = { passive: true };

  const S = Object.freeze({
    mainNav: "#mainNav",
    aliasSearch: "#aliasSearch",
    themeBtn: "#themeBtn",
    backToTop: "#backToTop",
    aliasCard: ".alias-card",
    tocLinks: "#tocSidebar .nav-link",
    sidebarClose: "#sidebarCloseBtn",
    sidebarToggle: "#sidebarToggleBtn",
    sidebar: "#tocSidebar",
    navHoverZone: "#navHoverZone",
    demoBtn: ".demo-btn",
  });

  const qs = (s: string) => document.querySelector(s);
  const qsa = (s: string) => document.querySelectorAll(s);
  const demoStates = new Map<string, { playing: boolean; tid: number | null; ci: number }>();

  function decodeEntities(str: string): string {
    const el = document.createElement("textarea");
    el.innerHTML = str;
    return el.value;
  }

  /* ═══ Error Banner ═══ */
  export function onError(ev: Event | PromiseRejectionEvent): void {
    const msg =
      ev instanceof ErrorEvent
        ? ev.message || "Unknown"
        : String((ev as PromiseRejectionEvent).reason || ev);
    let b = document.getElementById("fatal-alert");
    if (!b) {
      b = document.createElement("div");
      b.id = "fatal-alert";
      b.setAttribute("role", "alert");
      b.style.cssText =
        "position:fixed;top:0;left:0;right:0;z-index:9999;" +
        "background:#dc3545;color:#fff;padding:12px 20px;font-family:monospace;font-size:14px;";
      (document.body || document.documentElement).prepend(b);
    }
    const d = document.createElement("div");
    d.textContent = "\u26A0\uFE0F " + msg;
    b.appendChild(d);
  }

  /* ═══ Theme Toggle ═══ */
  export function initThemeToggle(): void {
    const btn = qs(S.themeBtn);
    if (!btn || (btn as HTMLElement).dataset.bound) return;
    (btn as HTMLElement).dataset.bound = "1";
    btn.addEventListener("click", () => {
      const html = document.documentElement;
      const next =
        html.getAttribute("data-bs-theme") === "dark" ? "light" : "dark";
      html.setAttribute("data-bs-theme", next);
      try {
        localStorage.setItem("ps-ref-theme", next);
      } catch {
        /* noop */
      }
      const i = btn.querySelector("i");
      if (i)
        i.className =
          next === "dark" ? "bi bi-sun-fill" : "bi bi-moon-stars-fill";
    });
    try {
      const saved = localStorage.getItem("ps-ref-theme");
      if (saved) {
        document.documentElement.setAttribute("data-bs-theme", saved);
        const i = btn.querySelector("i");
        if (i)
          i.className =
            saved === "dark" ? "bi bi-sun-fill" : "bi bi-moon-stars-fill";
      }
    } catch {
      /* noop */
    }
  }

  /* ═══ Search ═══ */
  export function initSearch(): void {
    const input = qs(S.aliasSearch) as HTMLInputElement | null;
    if (!input || input.dataset.bound) return;
    input.dataset.bound = "1";
    input.addEventListener("input", (e: Event) => {
      const q = ((e.target as HTMLInputElement).value || "")
        .toLowerCase()
        .trim();
      for (const card of qsa(S.aliasCard)) {
        (card as HTMLElement).style.display =
          !q ||
          ((card as HTMLElement).dataset.alias || "").includes(q) ||
          (card.textContent || "").toLowerCase().includes(q)
            ? ""
            : "none";
      }
    });
  }

  /* ═══ Scroll + Back-to-Top ═══ */
  export function initScroll(): void {
    const backToTop = qs(S.backToTop) as HTMLElement | null;
    if (backToTop && !backToTop.dataset.bound) {
      backToTop.dataset.bound = "1";
      backToTop.addEventListener("click", () =>
        window.scrollTo({ top: 0, behavior: "smooth" }),
      );
    }
    if (!document.body.dataset.boundScroll) {
      document.body.dataset.boundScroll = "1";
      const nav = qs(S.mainNav) as HTMLElement | null;
      window.addEventListener(
        "scroll",
        () => {
          const y = window.scrollY > SCROLL_THRESHOLD;
          if (nav) nav.classList.toggle("scrolled", y);
          if (backToTop) backToTop.classList.toggle("visible", y);
        },
        PASSIVE,
      );
    }
  }

  /* ═══ Header Auto-Hide ═══ */
  export function initNavAutoHide(): void {
    const nav = qs(S.mainNav) as HTMLElement | null;
    const zone = qs(S.navHoverZone);
    if (!nav || nav.dataset.boundHide) return;
    nav.dataset.boundHide = "1";

    let hideId: ReturnType<typeof setTimeout> | null = null;
    let lastY = 0;
    const navH = nav.offsetHeight || 72;

    function show() {
      nav!.classList.remove("nav-hidden");
      nav!.classList.add("nav-peek");
      if (hideId) clearTimeout(hideId);
    }
    function schedHide() {
      if (window.scrollY <= 0) return;
      hideId = setTimeout(() => {
        if (window.scrollY > 0) {
          nav!.classList.add("nav-hidden");
          nav!.classList.remove("nav-peek");
        }
      }, NAV_HIDE_DELAY);
    }

    window.addEventListener(
      "scroll",
      () => {
        const y = window.scrollY;
        if (y <= 0) {
          show();
          lastY = y;
          return;
        }
        if (y > lastY && y > navH) {
          nav.classList.add("nav-hidden");
          nav.classList.remove("nav-peek");
        }
        lastY = y;
      },
      PASSIVE,
    );

    if (zone) zone.addEventListener("mouseenter", show);
    nav.addEventListener("mouseenter", show);
    nav.addEventListener("mouseleave", () => {
      if (window.scrollY > 0) schedHide();
    });
  }

  /* ═══ Sidebar Toggle ═══ */
  export function initSidebarToggle(): void {
    const sidebar = qs(S.sidebar) as HTMLElement | null;
    const closeBtn = qs(S.sidebarClose) as HTMLElement | null;
    const toggleBtn = qs(S.sidebarToggle) as HTMLElement | null;
    if (!sidebar || !closeBtn || !toggleBtn || sidebar.dataset.boundSb) return;
    sidebar.dataset.boundSb = "1";

    function hide() {
      sidebar!.classList.add("sidebar-hidden");
      toggleBtn!.style.display = "flex";
      const sec = sidebar!.parentElement?.querySelector("section");
      if (sec) {
        sec.classList.remove("col-lg-9", "col-xl-10");
        sec.classList.add("col-lg-12", "col-xl-12");
      }
    }
    function show() {
      sidebar!.classList.remove("sidebar-hidden");
      toggleBtn!.style.display = "none";
      const sec = sidebar!.parentElement?.querySelector("section");
      if (sec) {
        sec.classList.remove("col-lg-12", "col-xl-12");
        sec.classList.add("col-lg-9", "col-xl-10");
      }
    }

    closeBtn.addEventListener("click", hide);
    toggleBtn.addEventListener("click", show);
  }

  /* ═══ TOC Active Tracking ═══ */
  export function initTocTracking(): void {
    if (document.body.dataset.boundToc) return;
    document.body.dataset.boundToc = "1";
    const secs: Array<{ link: Element; sec: Element }> = [];
    for (const link of qsa(S.tocLinks)) {
      const href = link.getAttribute("href");
      if (!href?.startsWith("#")) continue;
      const sec = qs(href);
      if (sec) secs.push(Object.freeze({ link, sec }));
    }
    if (!secs.length) return;
    window.addEventListener(
      "scroll",
      () => {
        const sp = window.scrollY + 150;
        for (const { link, sec } of secs)
          link.classList.toggle(
            "active",
            sp >= (sec as HTMLElement).offsetTop &&
              sp <
                (sec as HTMLElement).offsetTop +
                  (sec as HTMLElement).offsetHeight,
          );
      },
      PASSIVE,
    );
  }

  /* ═══ Typing Animation ═══ */
  export function startDemo(id: string): void {
    const block = document.querySelector(`[data-example-id="${id}"]`);
    if (!block) return;
    const cmd = decodeEntities(
      (block as HTMLElement).dataset.cmd || "",
    );
    const output = decodeEntities(
      (block as HTMLElement).dataset.output || "",
    );
    const typed = document.getElementById(`typed_${id}`);
    const cursor = document.getElementById(`cursor_${id}`);
    const outEl = document.getElementById(`output_${id}`);
    if (!typed || !cursor || !outEl) return;

    typed.textContent = "";
    outEl.textContent = "";
    outEl.classList.remove("visible");
    cursor.style.display = "inline-block";

    const state = { playing: true, tid: null as number | null, ci: 0 };
    demoStates.set(id, state);

    (function tick() {
      if (!demoStates.get(id)?.playing) return;
      if (state.ci < cmd.length) {
        typed!.textContent += cmd[state.ci++];
        state.tid = window.setTimeout(tick, TYPING_SPEED);
      } else {
        state.tid = window.setTimeout(() => {
          if (!demoStates.get(id)?.playing) return;
          cursor.style.display = "none";
          outEl.textContent = output;
          outEl.classList.add("visible");
          state.tid = window.setTimeout(() => {
            if (demoStates.get(id)?.playing) startDemo(id);
          }, RESTART_DELAY);
        }, OUTPUT_DELAY);
      }
    })();
  }

  export function stopDemo(id: string): void {
    const s = demoStates.get(id);
    if (s) {
      s.playing = false;
      if (s.tid) clearTimeout(s.tid);
    }
    const c = document.getElementById(`cursor_${id}`);
    if (c) c.style.display = "none";
  }

  export function isDemoPlaying(id: string): boolean {
    return demoStates.get(id)?.playing ?? false;
  }

  function toggleDemo(btn: HTMLElement): void {
    const id = btn.dataset.demoTarget;
    if (!id) return;
    const playing = demoStates.get(id)?.playing;
    if (playing) {
      stopDemo(id);
      btn.classList.remove("playing");
      const icon = btn.querySelector("i");
      const label = btn.querySelector("span");
      if (icon) icon.className = "bi bi-play-fill";
      if (label) label.textContent = "Start demo";
    } else {
      startDemo(id);
      btn.classList.add("playing");
      const icon = btn.querySelector("i");
      const label = btn.querySelector("span");
      if (icon) icon.className = "bi bi-pause-fill";
      if (label) label.textContent = "Stop demo";
    }
  }

  /* ═══ Demo Button Binding ═══ */
  export function initDemoButtons(): void {
    for (const btn of qsa(S.demoBtn)) {
      if ((btn as HTMLElement).dataset.bound) continue;
      (btn as HTMLElement).dataset.bound = "1";
      btn.addEventListener("click", () => toggleDemo(btn as HTMLElement));
    }
  }

  /* ═══ IntersectionObserver for auto-stop ═══ */
  export function initDemoVisibility(): void {
    if (!("IntersectionObserver" in window)) return;
    const obs = new IntersectionObserver(
      (entries) => {
        for (const e of entries) {
          if (!e.isIntersecting) {
            const id = (e.target as HTMLElement).dataset.exampleId;
            if (id && demoStates.get(id)?.playing) {
              stopDemo(id);
              const btn = (e.target as HTMLElement).querySelector(
                ".demo-btn",
              ) as HTMLElement | null;
              if (btn) {
                btn.classList.remove("playing");
                const icon = btn.querySelector("i");
                const label = btn.querySelector("span");
                if (icon) icon.className = "bi bi-play-fill";
                if (label) label.textContent = "Start demo";
              }
            }
          }
        }
      },
      { threshold: 0 },
    );
    for (const block of qsa(".example-block[data-example-id]"))
      obs.observe(block);
  }

  /* ═══ Vue.js App ═══ */
  export function initVueApp(): void {
    if (typeof (window as any).Vue === "undefined") {
      console.warn("Vue.js not loaded — fallback mode.");
      return;
    }
    try {
      const appEl = document.getElementById("aliasApp");
      if (!appEl) return;
      (window as any).Vue.createApp({
        data: () => ({ searchQuery: "" }),
        mounted() {
          (this as any).$nextTick(() => {
            if (appEl)
              for (const el of appEl.querySelectorAll("[data-bound]"))
                delete (el as HTMLElement).dataset.bound;
            initSearch();
            initThemeToggle();
            initDemoButtons();
            initDemoVisibility();
          });
        },
        updated() {
          (this as any).$nextTick(() => {
            initDemoButtons();
          });
        },
      }).mount("#aliasApp");
    } catch (e) {
      console.error("Vue init error:", e);
    }
  }

  /* ═══ Init ═══ */
  export function init(): void {
    window.addEventListener("error", onError);
    window.addEventListener("unhandledrejection", onError);
    initThemeToggle();
    initSearch();
    initScroll();
    initNavAutoHide();
    initSidebarToggle();
    initTocTracking();
    initDemoButtons();
    initDemoVisibility();
    initVueApp();
  }
}

export = Ps1App;
