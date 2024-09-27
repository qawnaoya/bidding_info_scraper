# 入札情報取得スクリプト

## 前提条件

官公需情報ポータルサイト 検索APIを用いて指定キーワードで案件情報を検索し出力する。
検索する案件の告示日はスクリプト実行日から指定日前とする。
APIの仕様の制約から、取得できる案件は1000件以内である。

## 設定ファイル

キーワード以外の設定情報は設定ファイルに保持される。
設定ファイルの名称はscraper.ini固定で起動時のカレントディレクトリから検索される。
設定ファイルの構造はWindows INI型式で以下のような記述である。

```
API_FQDN=http://www.kkj.go.jp/api/
MAX_SCRAPE_ROWS=1000
SCRAPE_ROWS=1000
SCRAPE_DAYS_DELTA=2
```

API_FQDNはAPIのエンドポイントを記載する。MAX_SCRAPE_ROWSは仕様上の取得可能案件数を設定する。現在は1000件である。SCRAPE_ROWSは本スクリプトが取得する案件数の上限を記載する。仕様より、MAX_SCRAPE_ROWS以下である必要がある。SCRAPE_DAYS_DELTAは実行日の前日から何日遡るかを指定する。

## 出力ファイル

出力ファイルはカレントディレクトリのexport.csvである。

## コマンドライン型式

コマンドライン型式は以下の通り。

```powershell
pwsh scrape.ps1 -query <検索文字列>
```

## 出力ファイル例

```csv
"項番","告示日","キー","自治体名","組織名","案件名"
"1","2024/09/26 0:00:00","eWFtYW5hc2hpL3lhbWFuYXNoaV9wcmVmLzIwMjQvMjAyNDA5MjZfMDA1NjMK","山梨県","山梨県","「凍結防止剤散布機の購入」に係る一般競争入札"
"2","2024/09/26 0:00:00","eWFtYWdhdGEvdGhyX21saXRfeWFtYWdhdGEvMjAyNC8yMDI0MDkyNl8wMTEyMwo=","山形県","国土交通省東北地方整備局山形河川国道事務所","防災教育資料編集印刷業務"
"3","2024/09/26 0:00:00","eWFtYWdhdGEvcHJlZi15YW1hZ2F0YS8yMDI0LzIwMjQwOTI2XzA1NzMyCg==","山形県","山形県","【置賜総合支庁建設部建設総務課】凍結抑制剤（液剤）の調達（令和6年10月16日入札）"
"4","2024/09/26 0:00:00","eWFtYWdhdGEvcHJlZi15YW1hZ2F0YS8yMDI0LzIwMjQwOTI2XzA1NzMxCg==","山形県","山形県","【置賜総合支庁建設部建設総務課】道路凍結抑制剤（塩化ナトリウム）の調達（令和6年10月16日）"
"5","2024/09/26 0:00:00","eWFtYWdhdGEvcHJlZi15YW1hZ2F0YS8yMDI0LzIwMjQwOTI2XzA1NzMzCg==","山形県","山形県","【上山警察署】白灯油の調達（令和6年10月24日入札）"
```

## 出力形式

|列番号|列名|型|内容|
|--|--|--|--|
|1|項番|整数|項番|
|2|告示日|日時|告示日|
|3|キー|文字列|案件のユニークキー|
|4|自治体名|文字列|案件の自治体名|
|5|組織名|文字列|案件の組織名|
|6|案件名|文字列|案件名|


