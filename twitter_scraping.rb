require 'open-uri'

if ARGV.size() != 1
  puts "Usage: Argv ACCOUNT_NAME"
  exit
end

$account_name = ARGV[0]

def get_min_position
  f = File.open("./#{$account_name}.html")
  text = f.read
  f.close
  $1 if text =~ /data-min-position="(.+?)"/
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

min_position = get_min_position
get_next_json(min_position)

