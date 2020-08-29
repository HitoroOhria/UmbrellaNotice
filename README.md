# :closed_umbrella: Umbrella Notice (天気予報通知アプリ)

2020/8/29 Bitbucket --> GitHub へ移行

## アプリケーションURL
[https://www.umbrellanotice.work](https://www.umbrellanotice.work)

## アプリケーションの概要

LINE公式アカウントにて、雨が降る場合に天気予報を通知するアプリケーションです。

## アプリケーションの画面

## クラウドアーキテクチャ

## アプリケーションの機能

- LINE公式アカウント
    - 天気予報通知
    - フォロー
        - 位置情報設定
            - テキスト送信
            - 位置座標送信
    - リッチメニュー
        - 天気予報の手動通知
        - 天気予報の通知時間変更
        - サイレント通知 ON/OFF
        - 天気予報の位置設定の変更
        - アカウント紐付けIDの発行
        - プロフィール画面リンク
- Web
    - 静的ページ
        - ホーム
        - 利用規約
        - プライバシーポリシー
    - アカウント
        - アカウント登録
        - ログイン / ログアウト
        - アカウント削除
        - ユーザー情報の変更
- Web API
    - 各リソースのCRUD
    - LINE Messaging API のハンドリング
    - AWS Lambda イベントの非同期処理

## アプリケーションの使用技術

- 仮想化技術
   - Docker
   - Docker Compose
   - ENTRYKIT
- フロントエンド
   - Nginx
   - React
        - TypeScript
        - Hooks
        - Redux
        - Redux Thunk
        - Amplify
- バックエンド
   - Unicorn
   - Rails
        - Active Model Serializers
        - Sidekiq
        - Redis Rails
- デプロイ
    - CircleCI
- テスト,品質管理
    - RSpec
    - RuboCop
    - ESLint
    - Prettier
- インフラ
    - Terraform
    - AWS ECS (EC2)
        - Nginx
        - Unicorn
        - Sidekiq
    - AWS ECR
    - AWS ELB (ALB)
    - AWS AutoScaling
    - AWS VPC
    - AWS Route53
    - AWS CertificateManager
- データーベース
    - MySQL
    - AWS RDS
- キャッシュストア
    - AWS ElasticCache (Redis)
- 定期イベント
    - AWS Lambda
- コンテンツ配信
    - AWS S3
    - AWS CloudFont
- ログ管理
    - AWS CloudWatch
- 機密情報管理
    - Rails Credentials
    - AWS SystemsManager (パラメータストア)
- LINE
    - 公式アカウント
    - リッチメニュー
- API
    - LINE
        - Login API
        - Messaging API
            - 応答メッセージ
            - プッシュメッセージ
            - リッチメニュー
            - クイックリプライ
    - OpenWeatherMap API (天気予報)
    - Geocoding API (住所→座標変換)

## 開発環境
- Visual Studio Code
    - TypeScript
    - React v16.13.1
- RubyMine
    - Ruby v2.7.1
    - Rails v6.0.3.2
- Docker
    - コンテナ構成
        - Nginx
        - Unicorn
        - Sidekiq
        - Redis
        - MySQL
- CircleCI
- RuboCop
- RSpec
