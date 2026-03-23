#!/bin/bash
# LINE Messaging API テスト送信スクリプト
# 使い方: bash .github/scripts/test_line.sh
# .env.local から LINE_CHANNEL_ACCESS_TOKEN と LINE_USER_ID を読み込む

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ENV_FILE="${SCRIPT_DIR}/../../.env.local"

if [ ! -f "$ENV_FILE" ]; then
  echo ".env.local が見つかりません。プロジェクトルートに作成してください。"
  exit 1
fi

source "$ENV_FILE"
TOKEN="$LINE_CHANNEL_ACCESS_TOKEN"
USER_ID="$LINE_USER_ID"

if [ -z "$TOKEN" ] || [ -z "$USER_ID" ]; then
  echo ".env.local に LINE_CHANNEL_ACCESS_TOKEN と LINE_USER_ID を設定してください"
  exit 1
fi

curl -s -X POST "https://api.line.me/v2/bot/message/push" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${TOKEN}" \
  -d "{
    \"to\": \"${USER_ID}\",
    \"messages\": [
      {
        \"type\": \"flex\",
        \"altText\": \"テスト通知\",
        \"contents\": {
          \"type\": \"bubble\",
          \"size\": \"kilo\",
          \"header\": {
            \"type\": \"box\",
            \"layout\": \"vertical\",
            \"contents\": [
              {
                \"type\": \"text\",
                \"text\": \"⚠️ おい、日記書けよ\",
                \"weight\": \"bold\",
                \"size\": \"lg\",
                \"color\": \"#FFFFFF\"
              }
            ],
            \"backgroundColor\": \"#C0392B\",
            \"paddingAll\": \"15px\"
          },
          \"body\": {
            \"type\": \"box\",
            \"layout\": \"vertical\",
            \"contents\": [
              {
                \"type\": \"text\",
                \"text\": \"$(TZ=Asia/Tokyo date +%Y-%m-%d 2>/dev/null || date +%Y-%m-%d)\",
                \"size\": \"sm\",
                \"color\": \"#999999\"
              },
              {
                \"type\": \"text\",
                \"text\": \"また書いてないの？\",
                \"weight\": \"bold\",
                \"size\": \"md\",
                \"margin\": \"md\",
                \"wrap\": true
              },
              {
                \"type\": \"text\",
                \"text\": \"GitHubで人生管理するとか言ってなかった？\",
                \"size\": \"sm\",
                \"color\": \"#666666\",
                \"margin\": \"sm\",
                \"wrap\": true
              },
              {
                \"type\": \"separator\",
                \"margin\": \"lg\"
              },
              {
                \"type\": \"box\",
                \"layout\": \"horizontal\",
                \"contents\": [
                  {
                    \"type\": \"box\",
                    \"layout\": \"vertical\",
                    \"contents\": [
                      {\"type\": \"text\", \"text\": \"🔥 Streak\", \"size\": \"xs\", \"color\": \"#999999\"},
                      {\"type\": \"text\", \"text\": \"連続記録: 0日 💀\", \"size\": \"sm\", \"weight\": \"bold\", \"color\": \"#666666\", \"wrap\": true}
                    ]
                  }
                ],
                \"margin\": \"lg\"
              },
              {
                \"type\": \"box\",
                \"layout\": \"horizontal\",
                \"contents\": [
                  {
                    \"type\": \"box\",
                    \"layout\": \"vertical\",
                    \"contents\": [
                      {\"type\": \"text\", \"text\": \"📊 Total\", \"size\": \"xs\", \"color\": \"#999999\"},
                      {\"type\": \"text\", \"text\": \"これまで0日分の記録\", \"size\": \"sm\", \"weight\": \"bold\"}
                    ]
                  }
                ],
                \"margin\": \"md\"
              }
            ],
            \"paddingAll\": \"15px\"
          },
          \"footer\": {
            \"type\": \"box\",
            \"layout\": \"vertical\",
            \"contents\": [
              {
                \"type\": \"text\",
                \"text\": \"言い訳はいいからClaude Code開け\",
                \"size\": \"xs\",
                \"color\": \"#FF0000\",
                \"align\": \"center\",
                \"weight\": \"bold\"
              }
            ],
            \"paddingAll\": \"10px\"
          }
        }
      }
    ]
  }"

echo ""
echo "送信完了（レスポンスが {} なら成功）"
