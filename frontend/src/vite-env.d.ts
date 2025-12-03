/// <reference types="vite/client" />

// Fallback definition so TypeScript knows about our env var even if vite/client
// types are unavailable before npm install.
declare interface ImportMetaEnv {
  readonly VITE_API_BASE_URL: string;
  readonly [key: string]: string;
}

declare interface ImportMeta {
  readonly env: ImportMetaEnv;
}


