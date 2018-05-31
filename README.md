# ReviewHub（仮）について
ReviewHub（仮）はレビュワーとレビュイーをつなげるマッチングプラットフォームです。一定以上の開発スキルを持っているレビュワーが部屋を作成することができ、その部屋に所属しているレビュイーからのレビューリクエストを受け、レビューを行っていくというサービスフローをイメージしています。

レビュワーが自身の部屋に月額費用を設定できるUIを想定しているため、ちょっとしたお小遣い稼ぎにレビューを行うといったことが可能です。レビュイーは月額費用を支払うことで、プロのエンジニアから本格的なレビューを受けることが出来るため、プログラミング言語学習の成果を飛躍的に伸ばせることが期待できます。

その他にも、将来的な設計として企業からのスカウト機能の実装も想定しており、レビュワー、レビュイー共にエンジニアとしてのキャリアの幅を広げるチャンスを作り出せることが期待できます。

こうしたサービスの開発に着手をしており、サービスの内容や思想に共感頂けるエンジニア、デザイナーがいらっしゃれば、是非ご連絡を頂けますと幸いです。

```
開発者： Yuta Toyokawa
連絡先： kppg42@gmail.com
```

# 開発環境
言語等については下記のバージョンを使用しています。
```
Ruby:  2.5.1
Rails: 5.2.0
MySQL: 5.7
```

## 事前準備
GitHub developer settingsにてReviewHubの開発環境用のOAuth Appsを作成しておく必要があります。
ReviewHubのOAuth Appsの作成が完了したら下記の通りに環境変数を自身のPC等に設定してください。

```bash
export GITHUB_KEY="今回取得したaccess_key"
export GITHUB_SECRET="今回取得したsecret_key"
```

## 開発環境セットアップ(Local環境)
下記の手順で開発環境のセットアップを進めてください。

### 依存ライブラリ
下記のライブラリを使用していますので、事前にインストールするようにしてください。
```
Redis: Sidekiqのqueueを一時的に保管するのに使用
```

### セットアップコマンド
下記のコマンドで開発環境のセットアップが可能です。
```bash
$ git clone git@github.com:toyokappa/reviewhub.git
$ cd reviewhub/
$ bundle install --path vendor/bundle
$ bin/rails db:create
$ bin/rails db:migrate
$ bin/rails s -b 0.0.0.0
```

## 開発環境セットアップ(Docker環境)
Docker環境も用意しています。Dockerでの環境構築を希望の場合は下記でセットアップしてください。
```bash
$ git clone git@github.com:toyokappa/reviewhub.git
$ cd reviewhub/
$ docker-compose build
$ docker-compose up
```

### pryを使ったデバッグを行う場合
pryを使ったデバッグを行う場合は下記の方法で立ち上げるようにしてください。
```bash
$ MANUAL=1 docker-compose up

# docker-composeが立ち上がったらターミナルの別のタブで下記コマンドを実行
$ docker-compose exec web rails s -b 0.0.0.0
```
