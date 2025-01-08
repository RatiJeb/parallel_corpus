# frozen_string_literal: true

namespace :db do
  desc 'Backup the database to a SQL file'
  task backup: :environment do
    filename = "db/backup_#{Time.zone.now.strftime('%Y%m%d%H%M%S')}.sql"
    config = Rails.configuration.database_configuration[Rails.env]

    # Parse the URL
    uri = URI.parse(config['url'])

    # Extract the components
    username = uri.user
    password = uri.password
    host = uri.host
    port = uri.port
    database = uri.path[1..] # Remove the leading '/' from the path

    `PGPASSWORD='#{password}' pg_dump -U #{username} -h #{host} -p #{port} #{database} > #{filename}`

    puts "Database backup saved to #{filename}"
  end
end
