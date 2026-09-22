// Konfigurasi Marp untuk deck kuliah PPB.
// Blok ```mermaid tidak dirender di browser, melainkan diganti dengan SVG yang
// sudah di-pre-render oleh tools/render_diagrams.py. Alasannya ada di komentar
// file itu: label mermaid mewarisi CSS halaman dan jadi terpotong.
const crypto = require('crypto');

const digest = (source) =>
  crypto.createHash('sha1').update(source.trim()).digest('hex').slice(0, 12);

module.exports = {
  themeSet: './themes',
  html: true,
  allowLocalFiles: true,
  engine: ({ marp }) =>
    marp.use((md) => {
      const fence = md.renderer.rules.fence;
      md.renderer.rules.fence = (tokens, idx, options, env, self) => {
        const token = tokens[idx];
        if (token.info.trim() === 'mermaid') {
          const src = `diagrams/${digest(token.content)}.svg`;
          return `<p class="diagram"><img src="${src}" alt="diagram"></p>`;
        }
        return fence(tokens, idx, options, env, self);
      };
    }),
};
