# clone_remote_db

Simple script to backup a PostgreSQL database from a remote server, and restore
it into a local database (such as development or staging).

## Installation

Install the gem.

    gem install clone_remote_db

And then execute:

    $ clone_remote_db --help

## Usage

The script can run with just arguments, but to make it easier, environments can
be defined in a a configuration file (by default: `$HOME/.clone_remote_db.yml`).

Below is an example YAML configuration file:

    ---
    defaults: &defaults
      local_dest: '~/pg_dumps/{remote_db}/%Y-%m/%Y-%m-%d_%H.%M.sql.gz'
      remote_user: 'postgres'
      gzip_opts:
        - '-9'
        - '--stdout'
      pg_dump_opts:
        - '-c'
        - '-O'
      pg_exclude_data:
        - 'versions'
    environments:
      foo:
        <<: *defaults
        host: 'foo-ssh-alias'
        local_db: 'foo_development'
        remote_db: 'foo_development'
        pg_exclude_data:
          - versions
          - session_logs
          - send_mails
          - job_logs
      bar:
        <<: *defaults
        host: 'bar-ssh-alias'
        local_db: 'bar_development'
        remote_db: 'bar_production'
        pg_exclude_data: []

You can avoid command-line arguments all together by using a configuration
file, so the below command would copy the remote database "foo_production" into
your local database "foo_development".

    clone_remote_db foo

If a database has already been downloaded, you can skip the download step and
import the saved backup right away:

    clone_remote_db foo --import-only \
        ~/pg_dumps/foo_production/2014-01/2014-01-01_12-00.sql.gz

Placeholders can be used for the --local-dest argument:

    clone_remote_db foo --local-dest \
        '~/pg_dumps/{remote_db}/%Y-%m/%Y-%m-%d_%H.%M.sql.gz'

Configuration values from the YAML file can be overwritten so you do not need
to modify the file:

    clone_remote_db foo --local-db foo_staging
    # instead of copying foo_production into foo_development, it will copy
    # foo_production into foo_staging

## Contributing

1. Fork it ( http://github.com/<my-github-username>/clone_remote_db/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
