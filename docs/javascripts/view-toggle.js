/* view-toggle.js (v2 - minimal, viewport-only)
 * 携帯で「💻 PC表示」ボタンを押すと viewport meta を width=1280 に切り替える。
 * CSS や body class は一切触らない（v1 でこれをやって layout を壊した教訓）。
 * 仕組みは Chrome の「デスクトップ表示を要求」と同じ：
 *   ブラウザが 1280px のページを物理画面幅に縮小して描画する。
 * これだけで充分 PC 表示になる。CSS の force-desktop は危険なので使わない。
 */
(function () {
  'use strict';

  var KEY = 'view-mode-v2';
  var mode;
  try { mode = localStorage.getItem(KEY) || 'auto'; } catch (e) { mode = 'auto'; }

  function setViewport(m) {
    var meta = document.querySelector('meta[name="viewport"]');
    if (!meta) {
      meta = document.createElement('meta');
      meta.setAttribute('name', 'viewport');
      (document.head || document.documentElement).appendChild(meta);
    }
    if (m === 'desktop') {
      meta.setAttribute('content', 'width=1280, initial-scale=1');
    } else {
      meta.setAttribute('content', 'width=device-width, initial-scale=1');
    }
  }

  function makeBtn() {
    if (document.getElementById('pc-view-btn')) return;
    var btn = document.createElement('button');
    btn.id = 'pc-view-btn';
    btn.type = 'button';
    btn.style.cssText = 'position:fixed;bottom:1rem;right:1rem;z-index:9999;padding:0.6rem 1rem;background:#5470c4;color:#fff;border:none;border-radius:999px;font-size:0.85rem;box-shadow:0 2px 6px rgba(0,0,0,0.3);cursor:pointer;font-family:sans-serif;';
    btn.textContent = (mode === 'desktop') ? '📱 モバイル' : '💻 PC表示';
    btn.onclick = function () {
      mode = (mode === 'desktop') ? 'auto' : 'desktop';
      try { localStorage.setItem(KEY, mode); } catch (e) {}
      setViewport(mode);
      btn.textContent = (mode === 'desktop') ? '📱 モバイル' : '💻 PC表示';
    };
    document.body.appendChild(btn);
  }

  /* viewport は init 時に同期で適用（描画前に行うとリフロー回数最小） */
  setViewport(mode);

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', makeBtn);
  } else {
    makeBtn();
  }

  /* mkdocs Material の navigation.instant 対策。
     URL が変わった後、ボタンが消えていれば再生成する。viewport は HTML 再読み込み時に
     書き換わるので毎回呼ぶ。 */
  var lastUrl = location.href;
  setInterval(function () {
    if (location.href !== lastUrl) {
      lastUrl = location.href;
      setTimeout(function () {
        setViewport(mode);
        makeBtn();
      }, 50);
    }
  }, 200);
})();
