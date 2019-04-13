require './tweet_data.rb'
require 'open-uri'

# アカウント名からトップページのhtmlを取得
def get_top_html
  url = "https://twitter.com/#{$account_name}"
  open(url).read
end

# htmlを与えるとmin-positionを返す
def get_min_position(top_html)
  top_html[/data-min-position="(.+?)"/, 1]
end

# min_positionからjsonを取得，次のmin_positionとhtmlに分割
def get_next_json(min_position)
  url = "https://twitter.com/i/profiles/show/#{$account_name}/timeline/tweets?include_available_features=1&include_entities=1&max_position=#{min_position}&reset_error_state=false"
  json_data = open(url).read
  
  # 正規表現によりそれぞれを抜き出す
  next_min = json_data[/"min_position":"(.+?)"/, 1]
  next_html = json_data[/"items_html":"(.+?)","new_latent_count"/, 1]

  # htmlの内容が崩れているので修正
  # \" -> "，\/ -> /，改行文字を改行するように再連結
  next_html = next_html.gsub(/\\u([\da-fA-F]{4})/) { [$1].pack('H*').unpack('n*').pack('U*') }
  # 何故かUTF-8で怒られるのでencode
  next_html = next_html.force_encoding('utf-8')
  next_html = next_html.encode("utf-16be", "utf-8", :invalid => :replace, :undef => :replace, :replace => '?').encode("utf-8")

  revised_html = ""
  next_html.split('\n').each do |line|
    revised_html << line.gsub(%r{\\"|\\/}, '\"'=>'"', '\/'=>'/') << "\n"
  end

  {"min_position" => next_min, "html" => revised_html}
end

# htmlからtweet情報を取得
def pull_out_tweet_data(html)
  # tweetのデータが入っているlistを正規表現で切り取り
  tweet_data = html.scan(%r{<li class="js-stream-item stream-item stream-item.+?\n\n</li>\n\n}m)
  tweet_data.each do |data|
    $tweet_data_list << TweetData.new(data)
  end
end

# tweetの日時を取得
def get_tweet_time_and_day(tweet_data)
  puts tweet_data[%r{<small class="time">(.+?)</small>}m][/title="(.+?)"/, 1]
end

def main
  top_html = get_top_html
  min_position = get_min_position(top_html)
  next_data = get_next_json(min_position)
  pull_out_tweet_data(top_html)
  pull_out_tweet_data(next_data["html"])

  $tweet_data_list.each do |tweet_data|
    puts "-"*50
    puts tweet_data.time_and_day
    puts "@" + tweet_data.account + "さんのTweet"
    puts tweet_data.tweet
    puts "-"*50
  end
end

# 初期設定やらmainの呼び出し
if __FILE__ == $0
  # アカウント名が指定されていない or @で始まらないアカウント名なら終了
  if ARGV.size() != 1 or ARGV[0] !~ /\A@.+\Z/
    puts "Usage: Argv @[ACCOUNT_NAME]"
    exit
  end

  # @を切り離したものをアカウント名として格納
  $account_name = ARGV[0].delete("@")
  $tweet_data_list = []

  main
end

