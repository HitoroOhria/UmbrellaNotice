# :closed_umbrella: Umbrella Notice (天気予報通知アプリ)

## アプリケーションURL
[https://www.umbrellanotice.work](https://www.umbrellanotice.work)

## アプリケーションの概要

LINE公式アカウントにて、雨が降る場合に天気予報を通知するアプリケーションです。

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
    - アカウント
        - アカウント登録
            - 本人確認メール送信
        - ログイン/ログアウト
            - LINE簡易ログイン
            - Facabook簡易ログイン
            - テストユーザーログイン
        - アカウント削除
        - ユーザー情報の変更
    - *Googleカレンダー連携 (実装中)*
        - 天気予報精度の向上

## アプリケーションの使用技術

- インフラ
    - AWS ECS (EC2)
        - Nginx
        - Unicorn
        - Sidekiq
    - AWS ELB (ALB)
    - AWS AutoScaling
    - AWS VPC
    - AWS Route53
    - AWS CertificateManager
- データーベース
    - AWS RDS
- セッション管理
    - AWS ElasticCache (Redis)
- 定期イベント
    - AWS Lambda
- 画像配信
    - AWS S3
- ログ管理
    - AWS CloudWatch
- 機密情報管理
    - Rails Credentials
    - AWS SystemsManager (パラメータストア)
- デプロイ
    - CircleCI
- テスト,品質管理
    - RSpec
    - RuboCop
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
    - *Googleカレンダー API (実装中)*
    - OpenWeatherMap API (天気予報)
    - Geocoding API (住所→座標変換)

## 開発環境
- RubyMine
- Ruby: v2.5.1
- Rails: v5.2.4
- Docker
    - Nginx
    - Unicorn
    - Sidekiq
    - Redis
    - MySQL
- Docker Compose
- ENTRYKIT
- CircleCI
- RuboCop
- RSpec
