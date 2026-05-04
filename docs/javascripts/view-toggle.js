/* view-toggle.js (v3 - reload-based)
 *
 * 変更点 vs v2:
 *   v2 ではボタンクリックで viewport meta を動的に書き換えていたが、一部のブラウザ
 *   (特にモバイル Safari) は <meta name="viewport"> の attribute 変更後の再評価を
 *   ロード後にはサポートしない / 部分的にしかサポートしないため、
 *   「localStorage は desktop なのに実表示はモバイルのまま」というズレが発生した。
 *
 *   v3 では「ボタンクリック → localStorage 更新 → location.reload()」の単純な流れに
 *   する。reload 直後の初期化で viewport meta を localStorage の値に合わせて設定するため、
 *   localStorage = 実表示 が必ず一致する。
 *
 *   ボタンラベルもこのルールに連動：
 *     view-mode-v2 === 'desktop' のとき: 「📱 モバイル表示」(タップでモバイルに戻る)
 *     それ以外:                          「💻 PC表示」     (タップで PC に切替)
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

  function labelFor(m) {
    return (m === 'desktop') ? '📱 モバイル表示' : '💻 PC表示';
  }

  function makeBtn() {
    if (document.getElementById('pc-view-btn')) return;
    var btn = document.createElement('button');
    btn.id = 'pc-view-btn';
    btn.type = 'button';
    btn.style.cssText = 'position:fixed;bottom:1rem;right:1rem;z-index:9999;padding:0.6rem 1rem;background:#5470c4;color:#fff;border:none;border-radius:999px;font-size:0.85rem;box-shadow:0 2px 6px rgba(0,0,0,0.3);cursor:pointer;font-family:sans-serif;';
    btn.textContent = labelFor(mode);
    btn.onclick = function () {
      var next = (mode === 'desktop') ? 'auto' : 'desktop';
      try { localStorage.setItem(KEY, next); } catch (e) {}
      /* viewport を動的に書き換えず、reload で確実に適用する */
      location.reload();
    };
    document.body.appendChild(btn);
  }

  /* 初期描画前に viewport を確定 */
  setViewport(mode);

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', makeBtn);
  } else {
    makeBtn();
  }

  /* mkdocs Material navigation.instant でページが SPA 遷移した場合、ボタンが消えるので
     再生成する。viewport は HTML 再ロードで再適用されるので、ここでは触らない。 */
  var lastUrl = location.href;
  setInterval(function () {
    if (location.href !== lastUrl) {
      lastUrl = location.href;
      setTimeout(makeBtn, 50);
    }
  }, 200);
})();
