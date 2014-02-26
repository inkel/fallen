module Fallen
  @running = false
  @pidfile = nil
  @stdin   = nil
  @stdout  = nil
  @stderr  = nil

  # Detachs this fallen angel from current process and runs it in
  # background
  #
  # @note Unless `STDIN`, `STDOUT` or `STDERR` are redirected to a
  #   file, these will be redirected to `/dev/null`
  def daemonize!
    Process.daemon true, (@stdin || @stdout || @stderr)
  end

  # Changes the working directory
  #
  # All paths will be relative to the working directory unless they're
  # specified as absolute paths.
  #
  # @param [String] path of the new workng directory
  def chdir! path
    Dir.chdir File.absolute_path(path)
  end

  # Path where the PID file will be created
  def pid_file path
    @pid_file = File.absolute_path(path)
  end

  # Reopens `STDIN` for reading from `path`
  #
  # This path is relative to the working directory unless an absolute
  # path is given.
  def stdin path
    @stdin = File.absolute_path(path)
    STDIN.reopen @stdin
  end

  # Reopens `STDOUT` for writing to `path`
  #
  # This path is relative to the working directory unless an absolute
  # path is given.
  def stdout path
    @stdout = File.absolute_path(path)
    STDOUT.reopen @stdout, "a"
  end

  # Reopens `STDERR` for writing to `path`
  #
  # This path is relative to the working directory unless an absolute
  # path is given.
  def stderr path
    @stderr = File.absolute_path(path)
    STDERR.reopen @stderr, "a"
  end

  # Returns `true` if the fallen angel is running
  def running?
    @running
  end

  # Brings the fallen angel to life
  #
  # If a PID file was provided it will try to store the current
  # PID. If this files exists it will try to check if the stored PID
  # is already running, in which case `Fallen` will exit with an error
  # code.
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

  # Runs the fallen angel
  #
  # This will set up `INT` & `TERM` signal handlers to stop execution
  # properly. When this signal handlers are called it will also call
  # the `stop` callback method and delete the pid file
  def run!
    save_pid_file
    @running = true
    trap(:INT) { interrupt }
    trap(:TERM) { interrupt }
    run
  end

  # Handles an interrupt (`SIGINT` or `SIGTERM`) properly as it
  # deletes the pid file and calles the `stop` method.
  def interrupt
    @running = false
    File.delete @pid_file
    stop
  end

  # Stops fallen angel execution
  #
  # This method only works when a PID file is given, otherwise it will
  # exit with an error.
  def stop!
    if @pid_file && File.exists?(@pid_file)
      pid = File.read(@pid_file).strip
      begin
        Process.kill :INT, pid.to_i
        File.delete @pid_file
      rescue Errno::ESRCH
        STDERR.puts "No daemon is running with PID #{pid}"
        exit 3
      end
    else
      STDERR.puts "Couldn't find a PID file"
      exit 1
    end
  end

  # Callback method to be run when fallen angel stops
  def stop; end

  private

  # Save the falen angel PID to the PID file specified in `pid_file`
  def save_pid_file
    File.open(@pid_file, "w") do |fp|
      fp.write(Process.pid)
    end if @pid_file
  end
end
