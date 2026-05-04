/* view-toggle.js
 * 右下に floating ボタンを置き、body に force-desktop クラスをトグルする。
 * モバイル端末でデスクトップレイアウトを強制表示するための仕組み。
 *
 * 状態は localStorage に保存（不可なら sessionStorage、それも不可なら次回はデフォルト）。
 * mkdocs Material の navigation.instant（SPA 的遷移）でも body class とボタンを再適用する。
 */
(function () {
  'use strict';

  var STORAGE_KEY = 'view-mode';
  var BTN_ID = 'view-toggle-btn';
  var LABEL_DESKTOP = '💻 デスクトップ表示';        // 💻 デスクトップ表示
  var LABEL_MOBILE  = '📱 モバイル表示に戻す';      // 📱 モバイル表示に戻す

  function safeGet() {
    try { var v = window.localStorage.getItem(STORAGE_KEY); if (v !== null) return v; } catch (e) {}
    try { var v2 = window.sessionStorage.getItem(STORAGE_KEY); if (v2 !== null) return v2; } catch (e) {}
    return 'auto';
  }

  function safeSet(mode) {
    try { window.localStorage.setItem(STORAGE_KEY, mode); return; } catch (e) {}
    try { window.sessionStorage.setItem(STORAGE_KEY, mode); } catch (e) {}
  }

  function applyMode(mode) {
    if (!document.body) return;
    if (mode === 'desktop') {
      document.body.classList.add('force-desktop');
    } else {
      document.body.classList.remove('force-desktop');
    }
    var btn = document.getElementById(BTN_ID);
    if (btn) {
      btn.textContent = (mode === 'desktop') ? LABEL_MOBILE : LABEL_DESKTOP;
      btn.setAttribute('aria-pressed', mode === 'desktop' ? 'true' : 'false');
    }
  }

  function ensureButton() {
    if (!document.body) return;
    if (document.getElementById(BTN_ID)) return;
    var btn = document.createElement('button');
    btn.id = BTN_ID;
    btn.className = 'view-toggle-btn';
    btn.type = 'button';
    btn.setAttribute('aria-label', '表示モード切替');
    btn.addEventListener('click', function () {
      var current = safeGet();
      var next = (current === 'desktop') ? 'auto' : 'desktop';
      safeSet(next);
      applyMode(next);
    });
    document.body.appendChild(btn);
  }

  function init() {
    var mode = safeGet();
    ensureButton();
    applyMode(mode);
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }

  /* mkdocs Material の navigation.instant 対策：
     URL が変わったら body class とボタンを再適用する（DOM が差し替わってボタンが消えても復元する）。 */
  var lastUrl = location.href;
  setInterval(function () {
    if (location.href !== lastUrl) {
      lastUrl = location.href;
      setTimeout(init, 50);
    }
  }, 200);
})();
