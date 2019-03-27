f = File.open("./json.json")
text = f.read
f.close
text.split('\n').each do |word|
  puts word.gsub(/\\u([\da-fA-F]{4})/) { [$1].pack('H*').unpack('n*').pack('U*') }
end
