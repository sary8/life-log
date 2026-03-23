# life-log

GitHubで日記をつける仕組み。

[「githubで人生を管理する」](https://zenn.dev/hand_dot/articles/85c9640b7dcc66) という記事に触発されて作った。コンセプトは最高だったけど、markdownを整えてgit pushする作業が毎晩できなくて1週間で挫折した。Claude Codeに話しかけるだけで全部やってくれるようにしたら続くようになった。

## どういうことができるか

Claude Codeにその日あったことを話す。

```text
今日さー、朝ジム行ってから仕事行って、会議3つもあってさ、
疲れたわ。でも夜は久しぶりに大学の友達と飯食って楽しかった
```

こうなる。

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

commitとpushまで自動。同じ日に何度話しかけても追記される。

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
  │ 📝 日記リマインダー → LINE煽り通知   │
  │ 📊 週次レビュー → LINE + weekly/  │
  └─────────────────────────────────┘
```

## セットアップ

### 1. リポジトリを用意する

このリポジトリをフォークするか、テンプレートとして使う。

### 2. Claude Codeにスキルを登録する

`skill.md` がスキルの定義ファイル。これをClaude Codeのスキルディレクトリにコピーする。

```bash
mkdir -p ~/.claude/skills/life-log
cp skill.md ~/.claude/skills/life-log/skill.md
```

あとはClaude Codeを開いて「今日あったこと」を話しかけるだけ。

### 3. LINE通知を設定する（任意）

日記を書き忘れた日に煽ってくるLINE通知。連続記録日数によってメッセージの圧が変わる。週次レビューもLINEに届く。

1. [LINE Developers](https://developers.line.biz/) でMessaging APIチャネルを作る
2. チャネルアクセストークンを発行
3. Botと友達になって自分のユーザーIDを取得
4. GitHubリポジトリの Settings > Secrets に登録:
   - `LINE_CHANNEL_ACCESS_TOKEN`
   - `LINE_USER_ID`

動作確認は `bash scripts/test_line.sh` で。`.env.local` にトークンを書いておく必要がある。

### 4. 自分用にカスタマイズする

- `CLAUDE.md` — Claude Codeへのプロジェクト設定。目標管理のルールやコミットメッセージのフォーマットが書いてある
- `skill.md` — 日記のカテゴリや振り返りのトーンを変えたければここをいじる
- `.markdownlint.jsonc` — lintルール

## ファイル構成

```text
life-log/
├── daily/                    # 日記 (YYYY/MM/DD.md)
├── weekly/                   # 週次レビュー（自動生成）
├── scripts/
│   └── test_line.sh          # LINE通知のテスト
├── .github/
│   ├── actions/
│   │   └── validate-diary/   # 日記バリデーション
│   └── workflows/
│       ├── lint.yml          # markdownlint
│       ├── validate-diary.yml
│       ├── daily-reminder.yml
│       ├── weekly-review.yml
│       └── goal-tracker.yml
├── skill.md                  # Claude Code スキル定義
├── CLAUDE.md                 # Claude Code プロジェクト設定
└── .markdownlint.jsonc
```

## CI/CD

pushされるたびにmarkdownlintと日記バリデーションが走る。日記として必要な要素（日付ヘッダー、カテゴリ、振り返り、タグ）が揃っているかチェックする。

## 目標管理

GitHub Issueで目標を管理する。`goal` ラベル付きのIssueにキーワードと目標回数を書いておくと、日記がpushされるたびにカウントされて、達成したらIssueが自動クローズされる。

```text
keyword: ジム
target: 10
period: 2026-03
```

Claude Codeに「今月ジム10回行きたい」と言えばIssueも作ってくれる。

## コスト

全部無料枠に収まる。GitHub Actionsのプライベートリポジトリ無料枠（月2,000分）に対して月15分もかからない。LINE Messaging APIの無料プラン（月200通）も日次通知なら余裕。

## 参考

- [githubで人生を管理する - Zenn](https://zenn.dev/hand_dot/articles/85c9640b7dcc66)
