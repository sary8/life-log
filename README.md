# life-log

Claude Codeに話しかけるだけで日記がつく。commit、push、CI/CDまで全自動。

## 使い方

```text
今日さー、朝ジム行ってから仕事行って、会議3つもあってさ、
疲れたわ。でも夜は久しぶりに大学の友達と飯食って楽しかった
```

↓

```markdown
# 2026-03-12（木）

## 🏋️ 健康

- 朝ジムに行った

## 💼 仕事

- 会議が3つあった

## 👥 プライベート

- 久しぶりに大学の友達とご飯を食べた

## 💭 振り返り

会議3つで疲れた一日だったけど、夜に友達と飯食えてよかった。

---

tags: #ジム #仕事 #友人
```

同じ日に何度話しかけても追記される。

## 全体像

```text
┌─────────────────┐
│  Claude Code    │ ── 話しかける ──→ daily/YYYY/MM/DD.md
│  (life-logスキル) │                         │
└─────────────────┘                         │ git push
                                            ▼
                                    ┌──────────────┐
                                    │ GitHub Actions │
                                    ├──────────────┤
                                    │ ✅ Lint        │
                                    │ ✅ Validate    │
                                    │ 🎯 Goal Track │
                                    └──────┬───────┘
                                           │
              ┌────────────────────────────┤
              ▼                            ▼
      ┌──────────────┐            ┌──────────────┐
      │ Issue自動クローズ│           │ LINE通知       │
      └──────────────┘            └──────────────┘

  ┌─────────────────────────────────┐
  │ cron (毎日21:00 / 毎週月曜)       │
  ├─────────────────────────────────┤
  │ 📝 日記リマインダー → LINE通知      │
  │ 📊 週次レビュー → LINE + weekly/  │
  └─────────────────────────────────┘
```

## セットアップ

### スキルの登録

```bash
mkdir -p ~/.claude/skills/life-log
cp skill.md ~/.claude/skills/life-log/skill.md
```

### LINE通知（任意）

日記未記入の日にリマインダーが届く。週次レビューも通知される。

1. [LINE Developers](https://developers.line.biz/) でMessaging APIチャネルを作成
2. チャネルアクセストークンとユーザーIDを取得
3. GitHub Secrets に `LINE_CHANNEL_ACCESS_TOKEN` と `LINE_USER_ID` を登録

動作確認: `bash .github/scripts/test_line.sh`（`.env.local` にトークンを記載）

## CI/CD

- **markdownlint** — push時にmarkdownのフォーマットチェック
- **日記バリデーション** — 日付ヘッダー、カテゴリ、振り返り、タグの構造チェック
- **目標トラッカー** — `goal` ラベル付きIssueのキーワードを日記からカウントし、達成でIssueを自動クローズ
- **日記リマインダー** — 毎日21:00 JST、未記入ならLINE通知（連続記録日数で煽りの強度が変わる）
- **週次レビュー** — 毎週月曜に `weekly/` へサマリーを自動生成

## カスタマイズ

- **`skill.md`** — 日記のカテゴリ、フォーマット、振り返りのトーン
- **`CLAUDE.md`** — コミットルール、目標管理のフォーマット
- **`.markdownlint.jsonc`** — lintルール

## 参考

- [githubで人生を管理する - Zenn](https://zenn.dev/hand_dot/articles/85c9640b7dcc66)

## License

[MIT](LICENSE)
