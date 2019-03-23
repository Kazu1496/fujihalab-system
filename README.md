# Fujihalab-System
千葉工業大学 藤原研のWebアプリ

## 入退室管理System
大学の研究室に接続することで入室となる。


研究室内でラズパイを動かして研究室Wifiを監視。  
研究室のWifiに接続された端末のMAC Addressを取得してRailsにPostする。  

ラズパイの中で動いているのはこの子。
[dainbe/scan_addr](https://github.com/dainbe/scan_addr)

## versions
- ruby - 2.6.0
- rails - 5.2.2

その他のgemはgemfileみて

## Usage

cloneして

```shell
git clone https://github.com/2357gi/who_is_there.git
```

Gemfileを適用して<br>
(developmentだったりtestだったりproductionだったりオプション設定してあるのでよしなに)

```shell
bundle install
```



DBをマイグレーションして

```
rails db:migrate
```

サーバーを立ち上げる

```
rails s
```

---
試しに新しくデータをpostするときは

```shell
curl -X POST -H "Content-Type: application/json" -d '{"addr": "XX:XX:XX:XX:XX", "password": "password", "status": true}' http://0.0.0.0:3000/api/v1/existences
```


