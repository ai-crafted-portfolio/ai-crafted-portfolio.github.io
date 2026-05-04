/* view-toggle.js (v4 - navigation.instant aware)
 *
 * v3 では reload ベースで「初回ロード時の localStorage = viewport = ラベル」を一致
 * させたが、mkdocs Material の navigation.instant（SPA 遷移）でページ B に飛んだ
 * ときに viewport meta が再評価されず、PC 表示モード中なのにモバイル表示で開いて
 * しまう問題が残った。
 *
 * v4 は SPA 遷移後にも viewport / ボタンを再適用するため、3 つのフックを併用：
 *   1) mkdocs Material が公開する document$ Observable に subscribe
 *      （標準的な navigation.instant のフック点）
 *   2) history.pushState の wrap + popstate listener
 *      （document$ 不在の環境向け fallback）
 *   3) URL polling（200ms 間隔、最終フォールバック）
 *
 * ボタンクリック動作は v3 と同じ：localStorage 更新 → location.reload()。
 * これで「reload した直後の初期化」または「SPA 遷移後の applyAll()」のどちらか
 * 必ず走るので、表示・viewport・ボタンラベルが乖離しない。
 */
(function () {
  'use strict';

  var KEY = 'view-mode-v2';

  function getMode() {
    try { return localStorage.getItem(KEY) || 'auto'; } catch (e) { return 'auto'; }
  }

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

  function labelFor(m) {
    return (m === 'desktop') ? '📱 モバイル表示' : '💻 PC表示';
  }

  function ensureButton() {
    if (document.getElementById('pc-view-btn')) return;
    if (!document.body) return;
    var btn = document.createElement('button');
    btn.id = 'pc-view-btn';
    btn.type = 'button';
    btn.style.cssText = 'position:fixed;bottom:1rem;right:1rem;z-index:9999;padding:0.6rem 1rem;background:#5470c4;color:#fff;border:none;border-radius:999px;font-size:0.85rem;box-shadow:0 2px 6px rgba(0,0,0,0.3);cursor:pointer;font-family:sans-serif;';
    btn.onclick = function () {
      var current = getMode();
      var next = (current === 'desktop') ? 'auto' : 'desktop';
      try { localStorage.setItem(KEY, next); } catch (e) {}
      /* 確実な反映のためフルリロード */
      location.reload();
    };
    document.body.appendChild(btn);
  }

  function updateButtonLabel() {
    var btn = document.getElementById('pc-view-btn');
    if (!btn) return;
    /* db2 v1.1 fix: read actual viewport meta, not just localStorage.
       On Db2 pages we observed a stale-state race where mode === 'desktop'
       but label still showed the auto label. Cross-check against the live
       viewport meta so the label always reflects what the user sees. */
    var meta = document.querySelector('meta[name="viewport"]');
    var content = meta ? (meta.getAttribute('content') || '') : '';
    var isDesktop = (getMode() === 'desktop') || /width=1280/.test(content);
    btn.textContent = isDesktop ? '📱 モバイル表示' : '💻 PC表示';
  }

  function applyAll() {
    var mode = getMode();
    setViewport(mode);
    ensureButton();
    updateButtonLabel();
  }

  /* 初回適用：viewport は描画前に確定したい */
  applyAll();

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', applyAll);
  }

  /* (1) mkdocs Material の document$ Observable に subscribe */
  function hookDocument$() {
    if (window.document$ && typeof window.document$.subscribe === 'function') {
      try {
        window.document$.subscribe(function () {
          /* 通知のたび viewport / ボタンを再適用 */
          setTimeout(applyAll, 0);
        });
        return true;
      } catch (e) { return false; }
    }
    return false;
  }
  if (!hookDocument$()) {
    /* document$ がページロード時点で未定義の場合に備え、短時間ポーリングして再試行 */
    var tries = 0;
    var iv = setInterval(function () {
      tries++;
      if (hookDocument$() || tries > 50) {  /* 約 10 秒で打ち切り */
        clearInterval(iv);
      }
    }, 200);
  }

  /* (2) history.pushState wrap + popstate listener (fallback) */
  window.addEventListener('popstate', function () { setTimeout(applyAll, 50); });
  try {
    var _ps = history.pushState;
    history.pushState = function () {
      var ret = _ps.apply(this, arguments);
      setTimeout(applyAll, 50);
      return ret;
    };
  } catch (e) { /* SecurityError 等はそのままスキップ */ }

  /* (3) URL polling - 最終フォールバック。200ms 間隔で URL 変化を検知 */
  var lastUrl = location.href;
  setInterval(function () {
    if (location.href !== lastUrl) {
      lastUrl = location.href;
      setTimeout(applyAll, 50);
    }
  }, 200);
})();
