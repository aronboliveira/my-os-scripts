/**
 * Vitest setup — shared DOM scaffolding for unit tests.
 */

/** Build a minimal DOM structure matching the aliases-references pages. */
export function buildTestDOM() {
  document.body.innerHTML = `
    <div class="nav-hover-zone" id="navHoverZone"></div>
    <button class="sidebar-toggle-btn" id="sidebarToggleBtn"
      title="Show sidebar" type="button" style="display:none"
      aria-label="Toggle sidebar">
      <i class="bi bi-layout-sidebar"></i><span>Menu</span>
    </button>
    <nav class="navbar navbar-expand-lg sticky-top" id="mainNav" aria-label="Main navigation">
      <div class="container-fluid">
        <a class="navbar-brand" href="#">Aliases</a>
        <div class="d-flex align-items-center gap-2">
          <input class="form-control form-control-sm" id="aliasSearch"
            type="search" placeholder="Search aliases..." aria-label="Search" required />
          <button class="btn btn-outline-secondary btn-sm" id="themeBtn"
            type="button" aria-label="Toggle theme">
            <i class="bi bi-sun-fill"></i>
          </button>
        </div>
      </div>
    </nav>
    <div class="container-fluid mt-3">
      <div class="row">
        <aside class="col-lg-3 col-xl-2" id="tocSidebar">
          <button class="sidebar-close-btn" id="sidebarCloseBtn"
            title="Hide sidebar" type="button" aria-label="Close sidebar">
            <i class="bi bi-x-lg"></i>
          </button>
          <nav class="nav flex-column nav-pills">
            <a class="nav-link" href="#sectionA">Section A</a>
            <a class="nav-link" href="#sectionB">Section B</a>
          </nav>
        </aside>
        <section class="col-lg-9 col-xl-10" id="aliasApp">
          <article id="sectionA">
            <h2 class="mb-3 pb-2 border-bottom">Section A</h2>
            <div class="card alias-card" data-alias="test-alias-a">
              <div class="card-body">
                <h5 class="alias-name">test-alias-a</h5>
                <p>Test alias A description.</p>
                <details class="example-details" data-examples-for="test-alias-a">
                  <summary><span>Usage Examples</span></summary>
                  <div class="examples-container">
                    <div class="example-block" data-example-id="ex_test_a_0"
                      data-cmd="test-alias-a" data-output="output A line1&#10;output A line2">
                      <button class="demo-btn" data-demo-target="ex_test_a_0"
                        type="button" aria-label="Start demo">
                        <i class="bi bi-play-fill"></i><span>Start demo</span>
                      </button>
                      <div>
                        <span class="prompt">$ </span>
                        <span class="typed-cmd" id="typed_ex_test_a_0"></span>
                        <span class="typing-cursor" id="cursor_ex_test_a_0" style="display:none"></span>
                      </div>
                      <div class="mock-output" id="output_ex_test_a_0"></div>
                    </div>
                  </div>
                </details>
              </div>
            </div>
            <div class="card alias-card" data-alias="test-alias-b">
              <div class="card-body">
                <h5 class="alias-name">test-alias-b</h5>
                <p>Test alias B — no examples.</p>
              </div>
            </div>
          </article>
          <article id="sectionB">
            <h2 class="mb-3 pb-2">Section B</h2>
            <div class="card alias-card" data-alias="another-alias">
              <div class="card-body">
                <h5 class="alias-name">another-alias</h5>
                <p>Another alias for section B.</p>
              </div>
            </div>
          </article>
        </section>
      </div>
    </div>
    <button class="btn btn-primary rounded-circle shadow" id="backToTop"
      type="button" aria-label="Back to top">
      <i class="bi bi-arrow-up"></i>
    </button>
  `;
}

/** Reset dataset bindings that prevent re-initialization */
export function resetBindings() {
  for (const el of document.querySelectorAll("[data-bound]"))
    delete el.dataset.bound;
  delete document.body.dataset.boundScroll;
  delete document.body.dataset.boundToc;
  const nav = document.getElementById("mainNav");
  if (nav) delete nav.dataset.boundHide;
  const sidebar = document.getElementById("tocSidebar");
  if (sidebar) delete sidebar.dataset.boundSb;
}
