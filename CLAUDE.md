# Life Log

GitHubで日記をつけるリポジトリ。

## 目標管理

ユーザーが「〜したい」「〜を目標にする」「〜回やる」のように目標を話したら、GitHub Issueを作成する。

```bash
gh issue create \
  --title "目標タイトル" \
  --label "goal" \
  --body "keyword: キーワード
target: 回数
period: YYYY-MM"
```

- `keyword`: 日記の箇条書きから検索される単語。ユーザーの言葉から最も適切な1語を選ぶ
- `target`: 目標回数（数値）
- `period`: 対象期間（YYYY-MM形式）。指定がなければ今月

ユーザーが目標の確認や進捗を聞いてきたら:

```bash
gh issue list --label "goal" --state open
```

## コミットルール

- `Co-Authored-By` はつけない
- `git commit -m "メッセージ"` でシンプルに。`cat` や `$()` は使わない
- メッセージは日本語

### 日記のコミットメッセージ

`MM/DD 日記を{動詞}` の形式。

- 新規: `3/13 日記を作成`
- 追記: `3/13 日記を更新`
- 修正: `3/12 日記を修正`

## 日記

`daily/YYYY/MM/DD.md` に保存する。詳細は life-log スキルに従う。
保存後は必ずコミット・プッシュまで行う。
