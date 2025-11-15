import { defineConfig } from '@vben/vite-config';

export default defineConfig(async () => {
  return {
    application: {},
    vite: {
      server: {
        host: '127.0.0.1', // 明确指定 host，防止一会localhost一会127.0.0.1导致跨域
        proxy: {
          '/.well-known': {
            changeOrigin: true,
            target: 'http://127.0.0.1:30001/',
          },
          '/api': {
            changeOrigin: true,
            target: 'http://127.0.0.1:30001/',
          },
          '/connect': {
            changeOrigin: true,
            target: 'http://127.0.0.1:30001/',
          },
          '/signalr-hubs': {
            changeOrigin: true,
            target: 'http://127.0.0.1:30001/',
            ws: true,
          },
        },
      },
    },
  };
});
