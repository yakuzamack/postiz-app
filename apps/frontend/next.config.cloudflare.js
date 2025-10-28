// @ts-check
import { withSentryConfig } from '@sentry/nextjs';

/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'export', // Static export for Cloudflare Pages
  images: {
    unoptimized: true, // Required for static export
  },
  experimental: {
    proxyTimeout: 90_000,
  },
  async headers() {
    return [{
      source: "/:path*",
      headers: [{
        key: "Document-Policy",
        value: "js-profiling",
      }],
    }];
  },
  reactStrictMode: false,
  transpilePackages: ['crypto-hash'],
  productionBrowserSourceMaps: true,
  
  webpack: (config, { buildId, dev, isServer, defaultLoaders }) => {
    if (!dev) {
      config.devtool = isServer ? 'source-map' : 'hidden-source-map';
    }
    return config;
  },
  
  // Remove redirects/rewrites that require server-side logic
  async redirects() {
    return [];
  },
  async rewrites() {
    return [];
  },
};

export default withSentryConfig(nextConfig, {
  org: process.env.SENTRY_ORG,
  project: process.env.SENTRY_PROJECT,
  authToken: process.env.SENTRY_AUTH_TOKEN,
  sourcemaps: {
    disable: false,
    assets: [
      ".next/static/**/*.js",
      ".next/static/**/*.js.map",
    ],
    ignore: [
      "**/node_modules/**",
      "**/*hot-update*",
      "**/_buildManifest.js",
      "**/_ssgManifest.js",
      "**/*.test.js",
      "**/*.spec.js",
    ],
    deleteSourcemapsAfterUpload: true,
  },
  release: {
    create: true,
    finalize: true,
    name: process.env.CF_PAGES_COMMIT_SHA || undefined,
  },
  widenClientFileUpload: true,
  telemetry: false,
  silent: process.env.NODE_ENV === 'production',
  debug: process.env.NODE_ENV === 'development',
  errorHandler: (error) => {
    console.warn("Sentry build error occurred:", error.message);
    return;
  },
});
