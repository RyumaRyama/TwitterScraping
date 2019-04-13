class TweetData

  def initialize(html)
    # tweetのデータが入っているlistを正規表現で切り取り
    @account = html[/data-screen-name="(.+?)"/, 1]
    @time_and_day = html[%r{<small class="time">(.+?)</small>}m][/title="(.+?)"/, 1]
    @tweet = html[%r{<div class="js-tweet-text-container">(.+?)</div>}m][%r{<p.+?>(.+?)</p>}m, 1]
    if @tweet =~ %r{(.*?)<a.+</a>}
      @tweet = $1
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
