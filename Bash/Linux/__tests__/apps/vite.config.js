import { resolve } from "path";
import { defineConfig } from "vite";

export default defineConfig({
  root: resolve(__dirname, "src"),
  build: {
    outDir: resolve(__dirname, "dist"),
    emptyOutDir: true,
    rollupOptions: {
      input: {
        bash: resolve(__dirname, "src/bash.html"),
        ps1: resolve(__dirname, "src/ps1.html"),
      },
    },
  },
  server: {
    port: 5174,
    strictPort: true,
  },
});
