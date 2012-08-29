# Fallen
A simpler daemon library for Ruby processes.

## Usage

```
require "fallen"

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
```

This will print _My name is Legion_ every 666 seconds on `STDOUT`. You can stop the daemon by pressing `CTRL+c`.

## Control your daemon
`Fallen` accepts the following methods:

* `daemonize!`: detaches the process and keep running it on background;
* `chdir!`: changes the current working directory of the process (useful for log and pid files);
* `pid_file`: allows to indicate a file path where the daemon `PID` will be stored; could be either an absolute path or a relative path to the current working directory (see `chdir!`);
* `stdout`, `stderr` & `stdin`: redirects the process `STDOUT`, `STDERR` and `STDIN` to either an absolute or relative file path; note that when a process is daemonized by default all these streams are redirected to `/dev/null`.

For example, the previous example could have the following lines before `Azazel.start!` to store the `PID` and log to a file:

```
Azazel.pid_file "/var/run/azazel.pid"
Azazel.stdout "/var/log/azazel.log"
Azazel.daemonize!
Azazel.start!
```

## CLI support
`Fallen` supports command line parameters, by default using the [`clap`](https://github.com/soveran/clap) gem. In order to enable command line support you need to do the following:

```
require "fallen"
require "fallen/cli"

module Azazel
  extend Fallen
  extend Fallen::CLI
  
  # ...
  
  def usage
    puts "..." # Your usage message
    # Default Fallen usage options
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
```

`Azazel.usage` will print the following:

```
Fallen introduced command line arguments:

  -D    Daemonize this process
  -C    Change directory.
  -P    Path to PID file. Only used in daemonized process.
  -out  Path to redirect STDOUT.
  -err  Path to redirect STDERR.
  -in   Path to redirect STDIN.
```

## License
See the `UNLICENSE` file included with this gem distribution.
