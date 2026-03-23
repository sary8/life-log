# Life Log

## 日記

`daily/YYYY/MM/DD.md` に保存。詳細は life-log スキルに従う。保存後は必ずコミット・プッシュまで行う。

## コミットルール

- コミットメッセージは日本語で `git commit -m "メッセージ"` のみ。`cat` や `$()` は使わない
- `Co-Authored-By` はつけない

### 日記のコミットメッセージ

`MM/DD 日記を{動詞}`

- 新規作成: `3/13 日記を作成`
- 追記: `3/13 日記を更新`
- 過去日付の修正: `3/12 日記を修正`

## 目標管理

「〜したい」「〜回やる」のような発言があったら `goal` ラベル付きの GitHub Issue を作成する。

```bash
gh issue create \
  --title "目標タイトル" \
  --label "goal" \
  --body "keyword: キーワード
target: 回数
period: YYYY-MM"
```

- `keyword` — 日記の箇条書きから検索される単語
- `target` — 目標回数
- `period` — 対象期間（YYYY-MM）。指定がなければ今月

進捗確認: `gh issue list --label "goal" --state open`
