/**
 * DOM fixture for PowerShell aliases-reference page tests.
 * Uses Ps1-suffixed IDs to avoid collisions with Bash section in combined pages.
 */

export function buildPs1DOM(): void {
  document.body.innerHTML = `
    <div class="nav-hover-zone" id="navHoverZone"></div>
    <button class="sidebar-toggle-btn" id="sidebarToggleBtn"
      title="Show sidebar" type="button" style="display:none"
      aria-label="Toggle sidebar">
      <i class="bi bi-layout-sidebar"></i><span>Menu</span>
    </button>
    <nav class="navbar navbar-expand-lg sticky-top" id="mainNav" aria-label="Main navigation">
      <div class="container-fluid">
        <a class="navbar-brand" href="#">PS Profile</a>
        <div class="d-flex align-items-center gap-2">
          <input class="form-control form-control-sm" id="aliasSearch"
            type="search" placeholder="Search aliases..." aria-label="Search" />
          <button class="btn btn-outline-secondary btn-sm" id="themeBtn"
            type="button" aria-label="Toggle theme">
            <i class="bi bi-moon-stars-fill"></i>
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
            <a class="nav-link" href="#systemSetup">System Setup</a>
            <a class="nav-link" href="#gitAliases">Git Aliases</a>
          </nav>
        </aside>
        <section class="col-lg-9 col-xl-10" id="aliasApp">
          <article id="systemSetup" class="mb-5">
            <h2 class="h3 mb-4">System Setup</h2>
            <div class="card alias-card mb-3" data-alias="Show-User">
              <div class="card-body">
                <h5 class="alias-name">Show-User</h5>
                <p>Display current user.</p>
                <details class="example-details">
                  <summary>Usage Examples</summary>
                  <div class="examples-container">
                    <div class="example-block" data-example-id="ex_show_user_0"
                      data-cmd="Show-User" data-output="aronboliveira">
                      <button class="demo-btn" data-demo-target="ex_show_user_0"
                        type="button" aria-label="Start demo">
                        <i class="bi bi-play-fill"></i><span>Start demo</span>
                      </button>
                      <div>
                        <span class="prompt">PS&gt; </span>
                        <span class="typed-cmd" id="typed_ex_show_user_0"></span>
                        <span class="typing-cursor" id="cursor_ex_show_user_0" style="display:none"></span>
                      </div>
                      <div class="mock-output" id="output_ex_show_user_0"></div>
                    </div>
                  </div>
                </details>
              </div>
            </div>
          </article>
          <article id="gitAliases" class="mb-5">
            <h2 class="h3 mb-4">Git Aliases</h2>
            <div class="card alias-card mb-3" data-alias="gs">
              <div class="card-body">
                <h5 class="alias-name">gs</h5>
                <p>Short for git status.</p>
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

export function resetPs1Bindings(): void {
  for (const el of document.querySelectorAll("[data-bound]"))
    delete (el as HTMLElement).dataset.bound;
  delete document.body.dataset.boundScroll;
  delete document.body.dataset.boundToc;
  const nav = document.getElementById("mainNav");
  if (nav) delete (nav as HTMLElement).dataset.boundHide;
  const sidebar = document.getElementById("tocSidebar");
  if (sidebar) delete (sidebar as HTMLElement).dataset.boundSb;
}
