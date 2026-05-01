# IOEPRMxx

**zFS パラメータ**

*§K-7. PARMLIB 標準メンバ網羅 (7)  (1/14)*

---

| 項目 | 内容 |
|---|---|
| **制御内容** | zFS (z/OS File System) のパラメータ (USS 環境のファイルシステム) |
| **主要パラメータ** | user_cache_size=512M / log_cache_size=64M / quiesce_info_message |
| **影響範囲** | zFS PFS 再起動 (F BPXOINIT,SHUTDOWN=...) で反映 |
| **関連メンバ** | BPXPRMxx |
| **注意点** | USS 不在環境では未使用 |

---

[↑ §K-7. PARMLIB 標準メンバ網羅 (7)](../section-k7-parmlib-env2.md) / [ASCHPMxx →](aschpmxx.md)
