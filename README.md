# karakeep-mcp-server

[KaraKeep](https://karakeep.app) の MCP サーバーを Railway 上でホストするためのリポジトリです。

[supergateway](https://github.com/supercorp-ai/supergateway) を使って、stdio ベースの `@karakeep/mcp` を SSE (Server-Sent Events) 経由でリモートアクセス可能にします。

## 構成

```
Claude (モバイル / Web)
    ↓ リモートMCP (SSE)
Railway (このリポジトリ / supergateway)
    ↓ stdio
@karakeep/mcp
    ↓ REST API
KaraKeep Cloud (cloud.karakeep.app)
```

## Railway へのデプロイ手順

### 1. このリポジトリをフォークまたはクローン

```bash
git clone https://github.com/<your-username>/karakeep-mcp-server.git
cd karakeep-mcp-server
```

### 2. Railway でプロジェクトを作成

1. [Railway](https://railway.app) にログイン
2. 「New Project」→「Deploy from GitHub repo」でこのリポジトリを選択

### 3. 環境変数を設定

Railway のプロジェクト設定から以下を追加してください。

| 変数名 | 値 | 説明 |
|--------|-----|------|
| `KARAKEEP_API_ADDR` | `https://cloud.karakeep.app` | KaraKeep のサーバーアドレス |
| `KARAKEEP_API_KEY` | `your_api_key` | KaraKeep の API キー |

**API キーの取得方法**: KaraKeep の Web UI → Settings → API Keys

### 4. ドメインを発行

Railway のプロジェクト設定から「Generate Domain」でパブリック URL を発行してください。

## Claude への設定方法

デプロイ後、Railway で発行された URL を使って Claude に MCP サーバーを登録します。

### Claude.ai (Web / モバイル)

Claude.ai の設定 → 「Model Context Protocol」→ 「Add MCP Server」から以下を入力します。

```
URL: https://<your-railway-domain>/sse
```

### Claude Desktop

`claude_desktop_config.json` に以下を追加してください。

```json
{
  "mcpServers": {
    "karakeep": {
      "command": "npx",
      "args": [
        "-y",
        "supergateway",
        "--sse",
        "https://<your-railway-domain>/sse"
      ]
    }
  }
}
```

## ヘルスチェック

`/health` エンドポイントでサーバーの稼働状況を確認できます。

```bash
curl https://<your-railway-domain>/health
```

## 利用可能なツール

`@karakeep/mcp` が提供するツールが利用できます。

- ブックマークの検索
- ブックマークの作成（URL・テキスト）
- リストへの追加・削除
- タグの付与・削除
- リストの作成

## ローカルでのテスト

```bash
# 環境変数を設定
export KARAKEEP_API_ADDR=https://cloud.karakeep.app
export KARAKEEP_API_KEY=your_api_key

# Docker でローカル起動
docker build -t karakeep-mcp-server .
docker run -p 8080:8080 \
  -e KARAKEEP_API_ADDR=$KARAKEEP_API_ADDR \
  -e KARAKEEP_API_KEY=$KARAKEEP_API_KEY \
  karakeep-mcp-server

# 別ターミナルで動作確認
curl http://localhost:8080/health
```
