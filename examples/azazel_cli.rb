require_relative "../lib/fallen"
require_relative "../lib/fallen/cli"

module Azazel
  extend Fallen
  extend Fallen::CLI

  def self.run
    while running?
      puts "My name is Legion"
      sleep 666
    end
  end

  def self.usage
    puts fallen_usage
  end
end

case Clap.run(ARGV, Azazel.cli).first
when "start"
  Azazel.start!
when "stop"
  Azazel.stop!
else
  Azazel.usage
end
