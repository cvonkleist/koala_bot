require "dependencies"
require "net/yail"

class Cycler
  def initialize(elements)
    @elements = elements
    @random_elements_pool = []
  end

  def next
    @random_elements_pool = @elements.clone if @random_elements_pool.empty?
    @random_elements_pool.delete_at(rand(@random_elements_pool.count))
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
  if event.channel && event.message.match(%r(k.*o.*a.*l.*a)i)
    irc.msg(event.channel, koala_lines.next)
  end
end

irc.start_listening!
