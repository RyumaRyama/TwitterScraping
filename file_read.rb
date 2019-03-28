def get_next_page_json(text)
  $1 if text =~ /data-min-position="(.+?)"/
end

f = File.open("./wassyoi.html")
text = f.read
p get_next_page_json(text)
f.close

# text.split('\n').each do |word|
#   puts word.gsub(/\\u([\da-fA-F]{4})/) { [$1].pack('H*').unpack('n*').pack('U*') }
# end
