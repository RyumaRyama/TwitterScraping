require 'open-uri'

# 仮置き，htmlをファイルから読み込む
def get_top_html
  url = "https://twitter.com/#{$account_name}"
  open(url).read
end

# htmlを与えるとmin-positionを返す
def get_min_position(top_html)
  $1 if top_html =~ /data-min-position="(.+?)"/
end

# min_positionからjsonを取得，次のmin_positionとhtmlに分割
def get_next_json(min_position)
  url = "https://twitter.com/i/profiles/show/#{$account_name}/timeline/tweets?include_available_features=1&include_entities=1&max_position=#{min_position}&reset_error_state=false"
  json_data = open(url)
  p json_data.charset

  # 正規表現によりそれぞれを抜き出す
  next_min = $1 if json_data =~ /"min_position":"(.+?)"/
  next_html = $1 if json_data =~ /"items_html":"(.+?)","new_latent_count"/

  {"min_position" => next_min, "html" => next_html}
end

# htmlからtweet情報を取得
def pull_out_tweet_data(html)
  html = html.gsub(/\\u([\da-fA-F]{4})/) { [$1].pack('H*').unpack('n*').pack('U*') }
  tweet_data = html.scan(%r{<li class=\"js-stream-item stream-item stream-item\n\".+?\n\n<\/li>\n\n})
  # p tweet_data
end

def main
  top_html = get_top_html
  min_position = get_min_position(top_html)
  next_data = get_next_json(min_position)
  pull_out_tweet_data(next_data["html"])
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

  main
end

