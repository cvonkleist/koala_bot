require "dependencies"
require "net/yail"

class Cycler
  def initialize(elements)
    raise "elements empty" if elements.empty?
    @elements = elements
    @idx_max  = elements.length - 1
    @idx      = 0
  end

  def next
    r = @elements[@idx]
    @idx = (@idx == @idx_max) ? 0 : (@idx + 1)
    r
  end
end

server_host = ARGV.shift
server_port = (ARGV.shift || 6667).to_i

koala_lines = Cycler.new(File.read("koalas.txt").split("\n"))

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
      irc.msg(event.channel, koala_lines.next)
    end
  else
    puts "unhandled event: #{event.inspect}"
  end
end

irc.start_listening!
