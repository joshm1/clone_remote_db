require 'optparse'

class CloneRemoteDb::Loader
  attr_reader :script

  def initialize(script)
    @script = script
  end

  def parse_opts!
    OptionParser.new do |opts|
      banner(opts)
      version(opts)
      opt(opts, :local_db, "Local postgresql database name", arg: 'DBNAME', short: '-l')
      opt(opts, :remote_db, "Remote postgresql database name", arg: 'DBNAME', short: '-r')
      opt(opts, :host, "Host of the postgresql database", arg: 'HOST', short: '-h')
      opt(opts, :import_only, "Skip download and provide path to dump.sql.gz file", arg: 'PATH')
      opt(opts, :local_dest, "The path to save the dump.sql.gz file to", arg: 'PATH')
      opt(opts, :dry_run, "Don't actually do anything", short: '-n')
    end.parse!
    options
  end

  def die(key_or_msg, msg = nil, exit_code = -1)
    if key_or_msg.is_a?(String)
      $stderr.puts "Error: #{key_or_msg}"
    else
      arg = '--' + key_or_msg.to_s.gsub('_', '-')
      $stderr.puts "Error: argument #{arg} #{msg}."
    end
    exit(exit_code)
  end

  def banner(opts)
    opts.banner = <<-EOS
Download and import a remote (PostgreSQL) database into a local database.

Usage:
        #{script} [options]

Options:
EOS
  end

  def version(opts)
    opts.on('--version', 'Show the version') do
      io.puts "clone_remote_db #{CloneRemoteDb::VERSION} (c) Josh McDade"
      exit(0)
    end
  end

  def opt(opts, key, msg, arg_opts = {})
    arg = "--#{key.to_s.gsub('_', '-')}"
    arg << " #{arg_opts[:arg]}" if arg_opts[:arg]
    on_args = [arg, msg]
    on_args.unshift(arg_opts[:short]) if arg_opts[:short]
    opts.on(*on_args, msg) do |v|
      options[key] = v
    end
  end

  def options
    @options ||= {}.merge(defaults)
  end

  def defaults
    {
      local_dest: '~/pg_dumps/{remote_db}/%Y-%m/%Y-%m-%d_%H.%M.sql.gz',
      gzip_opts: %w(-9 --stdout),
      pg_dump_opts: %w(-c -O),
      pg_exclude_data: %w(versions),
      remote_user: 'postgres'
    }
  end

  def replace_variables(str)
    new_str = str
    %w(local_db remote_db remote_user).each do |arg|
      new_str = new_str.gsub('{' + arg + '}', options[arg.to_sym])
    end
    new_str
  end
end
