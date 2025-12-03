declare interface ImportMetaEnv {
  readonly VITE_API_BASE_URL: string;
  readonly [key: string]: string;
}

declare interface ImportMeta {
  readonly env: ImportMetaEnv;
}

declare module "vite/client" {
  export {};
}


