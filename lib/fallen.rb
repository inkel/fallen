module Fallen
  @running = false
  @pidfile = nil
  @stdin   = nil
  @stdout  = nil
  @stderr  = nil

  def daemonize!
    Process.daemon true
  end

  def chdir! path
    Dir.chdir File.absolute_path(path)
  end

  def pid_file path
    @pid_file = File.absolute_path(path)
  end

  def stdin path
    @stdin = File.absolute_path(path)
    STDIN.reopen @stdin
  end

  def stdout path
    @stdout = File.absolute_path(path)
    STDOUT.reopen @stdout, "a"
  end

  def stderr path
    @stderr = File.absolute_path(path)
    STDERR.reopen @stderr, "a"
  end

  def running?
    @running
  end

  def start!
    if @pid_file && File.exists?(@pid_file)
      pid = File.read(@pid_file).strip
      begin
        Process.kill 0, pid.to_i
        STDERR.puts "Daemon is already running with PID #{pid}"
        exit 2
      rescue Errno::ESRCH
        run!
      end
    else
      run!
    end
  end

  def run!
    save_pid_file
    @running = true
    trap(:INT) { @running = false; stop }
    trap(:TERM) { @running = false; stop }
    run
  end

  def stop!
    if @pid_file && File.exists?(@pid_file)
      pid = File.read(@pid_file).strip
      begin
        Process.kill :INT, pid.to_i
      rescue Errno::ESRCH
        STDERR.puts "No daemon is running with PID #{pid}"
        exit 3
      end
    else
      STDERR.puts "Couldn't find a PID file"
      exit 1
    end
  end

  def stop; end

  private

  def save_pid_file
    File.open(@pid_file, "w") do |fp|
      fp.write(Process.pid)
    end if @pid_file
  end
end
