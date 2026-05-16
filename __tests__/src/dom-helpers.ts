/**
 * DOM helper utilities for unit tests.
 * Provides mock IntersectionObserver and other browser APIs.
 */

export function mockIntersectionObserver(): void {
  const entriesMap = new Map<Element, boolean>();

  class MockIntersectionObserver {
    callback: IntersectionObserverCallback;
    constructor(callback: IntersectionObserverCallback) {
      this.callback = callback;
    }
    observe(target: Element) {
      entriesMap.set(target, true);
    }
    unobserve(target: Element) {
      entriesMap.delete(target);
    }
    disconnect() {
      entriesMap.clear();
    }
    triggerIntersect(target: Element, isIntersecting: boolean) {
      entriesMap.set(target, isIntersecting);
      this.callback(
        [
          {
            target,
            isIntersecting,
            intersectionRatio: isIntersecting ? 1 : 0,
            boundingClientRect: {} as DOMRectReadOnly,
            intersectionRect: {} as DOMRectReadOnly,
            rootBounds: null,
            time: Date.now(),
          },
        ],
        this as unknown as IntersectionObserver,
      );
    }
  }

  (window as unknown as Record<string, unknown>).IntersectionObserver =
    MockIntersectionObserver;
}

export function sleep(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

/**
 * Find all elements matching a CSS selector within a scope.
 */
export function qs(selector: string, scope?: Element): Element | null {
  return (scope || document).querySelector(selector);
}

export function qsa(selector: string, scope?: Element): NodeListOf<Element> {
  return (scope || document).querySelectorAll(selector);
}
