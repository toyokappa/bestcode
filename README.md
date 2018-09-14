# BestCodeについて
BestCodeはレビュワーとレビュイーをつなげるマッチングプラットフォームです。一定以上の開発スキルを持っているレビュワーが部屋を作成することができ、その部屋に所属しているレビュイーからのレビューリクエストを受け、レビューを行っていくというサービスフローをイメージしています。

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
Ruby:    2.5.1
Rails:   5.2.0
MySQL:   5.7
Node.js: v10.0.0
Webpack: 4.10
```

サーバサイドはRails、フロントエンドはWebpackを使用しています。下記にも記載をしますが、JSのパッケージ管理はYarnで行いますのでLocalで環境構築をする場合は事前にインストールをしていただくようにお願いします。(Dockerの場合は不要)

## 事前準備
GitHub developer settingsにてBestCodeの開発環境用のOAuth Appsを作成しておく必要があります。
BestCodeのOAuth Appsの作成が完了したら下記の通りに環境変数を自身のPC等に設定してください。

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
Yarn:  JSライブラリの管理に仕様
```

### セットアップコマンド
下記のコマンドで開発環境のセットアップが可能です。
```bash
$ git clone git@github.com:toyokappa/bestcode.git
$ cd bestcode/
$ bundle install --path vendor/bundle
$ bin/rails db:create
$ bin/rails db:migrate
$ bin/rails s -b 0.0.0.0
```

フロントはwebpack-dev-serverでコンパイルしているため、下記のコマンドでフロントのサーバーを立ち上げてください。
```bash
$ yarn run start
```

## 開発環境セットアップ(Docker環境)
Docker環境も用意しています。Dockerでの環境構築を希望の場合は下記でセットアップしてください。
```bash
$ git clone git@github.com:toyokappa/bestcode.git
$ cd bestcode/

# 初回のみ実行。5〜10分程度かかります。
$ docker-compose build
$ docker-compose up
```

Webpackのサーバー起動が不安定で、起動時に落ちることが多々あります。その場合は`docker-compose`を再起動してください。

### pryを使ったデバッグを行う場合
pryを使ったデバッグを行う場合は下記の方法で立ち上げるようにしてください。
```bash
$ MANUAL=1 docker-compose up

# docker-composeが立ち上がったらターミナルの別のタブで下記コマンドを実行
$ docker-compose exec web rails s -b 0.0.0.0
```
