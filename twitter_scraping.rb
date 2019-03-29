require 'open-uri'

def main
  top_html = get_top_html
  min_position = get_min_position(top_html)
  get_next_json(min_position)
end

# 仮置き，htmlをファイルから読み込む
def get_top_html
  f = File.open("./#{$account_name}.html")
  f.read
  f.close
end

# htmlを与えるとmin-positionを返す
def get_min_position(top_html)
  $1 if top_html =~ /data-min-position="(.+?)"/
end

def get_next_json(min_position)
  url = "https://twitter.com/i/profiles/show/#{$account_name}/timeline/tweets?include_available_features=1&include_entities=1&max_position=#{min_position}&reset_error_state=false"
  json_data = open(url).read

  next_min = $1 if json_data =~ /"min_position":"(.+?)"/
  page_html = $1 if json_data =~ /"items_html":"(.+?)","new_latent_count"/

  page_html.split('\n').each do |line|
    puts line.gsub(/\\u([\da-fA-F]{4})/) { [$1].pack('H*').unpack('n*').pack('U*') }
  end
  p next_min
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
