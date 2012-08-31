require "test/unit"
require "tempfile"

require_relative "../lib/fallen"

class FallenTest < Test::Unit::TestCase
  def test_stdout
    stdout = Tempfile.new("stdout")

    fork do
      azazel = Module.new do
        extend Fallen

        def self.run
          puts "Azazel"
        end
      end

      azazel.stdout stdout.path
      azazel.start!
    end

    Process.wait

    assert_equal "Azazel\n", open(stdout).read
    stdout.unlink
  end

  def test_stderr
    stderr = Tempfile.new("stderr")

    fork do
      lucifer = Module.new do
        extend Fallen

        def self.run
          STDERR.puts "Lucifer"
        end
      end

      lucifer.stderr stderr.path
      lucifer.start!
    end

    Process.wait

    assert_equal "Lucifer\n", open(stderr).read
    stderr.unlink
  end

  def test_pid_file
    pid_file = "/tmp/beelzebub.pid"
    File.unlink pid_file if File.exists? pid_file

    pid = fork do
      beelzebub = Module.new do
        extend Fallen

        def self.run; end
      end

      beelzebub.pid_file pid_file
      beelzebub.start!
    end

    Process.wait

    assert_equal pid.to_s, open(pid_file).read
    File.unlink pid_file
  end
end
