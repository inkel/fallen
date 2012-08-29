require_relative "../lib/fallen"

module Azazel
  extend Fallen

  def self.run
    while running?
      puts "My name is Legion"
      sleep 666
    end
  end
end

Azazel.start!
