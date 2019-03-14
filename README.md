# Who's in there?
研究室に誰が居るかを表示したり滞在時間を管理するやつ

研究室のNFCリーダーを動かしてるPython**2**から出席情報をPostしてもらって、
そいつをDBに後々検索しやすい形で保存する。

# 使ってるもの
#### server side
- ruby - 2.6.0
- rails - 5.2.2

その他のgemはgemfileみて

#### client side
- shell script


# Usage

cloneして

```shell
git clone https://github.com/2357gi/who_is_there.git
```

Gemfileを適用して<br>
(developmentだったりtestだったりproductionだったりオプション設定してあるのでよしなに)

```shell
bundle install
```



DBをマイグレーションして、dbの初期値を適用して、

```
rails db:migrate
rails db:seeds
```

サーバーを立ち上げる

```
rails s
```

---
試しに新しくデータをpostするときは

```shell
curl -X POST -H "Content-Type: application/json" -d '{"name": "Buri", "password": "secure" "status": true}' http://0.0.0.0:3000/api/v1/existences
```

**研究室で動かすときにはコレができないようにAPIつくったり何らかの対策を講じる事！**


#
