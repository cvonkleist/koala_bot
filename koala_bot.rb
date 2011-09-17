require "dependencies"
require "net/yail"

server_host = ARGV.shift
server_port = (ARGV.shift || 6667).to_i

$koala_lines = File.read("koalas.txt").split("\n")

def random_line
  $koala_lines[rand($koala_lines.count)]
end

irc = Net::YAIL.new(
  :address   => server_host,
  :port      => server_port,
  :username  => "KoalaBot",
  :realname  => "Koala Bot",
  :nicknames => ["koala_bot", "koala_bot_"],
  :loud      => true
)

irc.on_welcome do |event|
  irc.join("#skillhouse")
end

irc.on_msg do |event|
  if event.pm?
  elsif event.channel
    if event.message.match(%r(k.*o.*a.*l.*a)i)
      irc.msg(event.channel, random_line)
    end
  else
    puts "unhandled message (server?)"
  end
end

irc.start_listening!
