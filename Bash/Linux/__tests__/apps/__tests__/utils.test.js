import { describe, it, expect } from "vitest";
import { decodeEntities } from "../src/js/utils.js";

describe("utils", () => {
  describe("decodeEntities", () => {
    it("decodes HTML entities", () => {
      expect(decodeEntities("&amp;")).toBe("&");
      expect(decodeEntities("&lt;")).toBe("<");
      expect(decodeEntities("&gt;")).toBe(">");
      expect(decodeEntities("&#39;")).toBe("'");
      expect(decodeEntities("&quot;")).toBe('"');
    });

    it("decodes numeric entities", () => {
      expect(decodeEntities("&#10;")).toBe("\n");
      expect(decodeEntities("&#10003;")).toBe("\u2713");
    });

    it("passes through plain text unchanged", () => {
      expect(decodeEntities("hello world")).toBe("hello world");
      expect(decodeEntities("")).toBe("");
    });

    it("decodes mixed content", () => {
      expect(decodeEntities("a &amp; b &lt; c")).toBe("a & b < c");
    });
  });
});
