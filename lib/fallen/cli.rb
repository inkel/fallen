require "clap"

module Fallen::CLI
  def cli
    {
      "-D"   => self.method(:daemonize!),
      "-C"   => self.method(:chdir!),
      "-P"   => self.method(:pid_file),
      "-out" => self.method(:stdout),
      "-err" => self.method(:stderr),
      "-in"  => self.method(:stdin)
    }
  end

  def fallen_usage
    <<-USAGE
Fallen introduced command line arguments:

  -D    Daemonize this process
  -C    Change directory.
  -P    Path to PID file. Only used in daemonized process.
  -out  Path to redirect STDOUT.
  -err  Path to redirect STDERR.
  -in   Path to redirect STDIN.
    USAGE
  end
end
