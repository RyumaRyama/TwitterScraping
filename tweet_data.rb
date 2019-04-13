class TweetData

  def initialize(html)
    # アカウント名を取得
    @account = html[/data-screen-name="(.+?)"/, 1]

    # tweet日時を取得
    @time_and_day = html[%r{<small class="time">(.+?)</small>}m][/title="(.+?)"/, 1]

    # tweet内容のみを抽出
    @tweet = html[%r{<div class="js-tweet-text-container">(.+?)</div>}m][%r{<p.+?>(.+?)</p>}m, 1]
    # 画像があればリンクを削除
    @tweet = $1 if @tweet =~ %r{(.*?)<a.+</a>}
    # 絵文字なども削除
    if @tweet =~ /<img .+? title="(.+?)" .+?>/
      img = "[" + $1 + "]"
      @tweet = @tweet.gsub(/<img.+?>/, img)
    end
  end

  def account
    @account
  end

  def time_and_day
    @time_and_day
  end

  def tweet
    @tweet
  end

end
