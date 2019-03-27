# TwitterScraping
I will try scraping.

スクレイピングしてみたかったのでやってみます．
Twitterアカウントを指定して，鍵アカでなければ過去のツイートを読み込みなにかしらしてみます．
（例：「尊い」をカウントして過去一年ぐらいにどれだけ尊くなったのか調べる謎メーターなど）


## たぶんこうすればできる
1. ```https://twitter.com/[アカウント名]```に対してGETを送り，htmlを取得．
2. その中の```data-min-position="[0-9]*"```を読み取ることで次の取得先を知る．
3. 2でわかった数値を使い```https://twitter.com/i/profiles/show/[アカウント名]/timeline/tweets?include_available_features=1&include_entities=1&max_position=[2でわかった数値]&reset_error_state=false```をGET，jsonフィアルを取得．
4. その中の```min_position":"[0-9]*"```を次のGETへ，```"items_html":"[htmlがずらずら]"```がTweet情報となっている．
5. 3,4を繰り返すことで次々とTweetを取得できる．
