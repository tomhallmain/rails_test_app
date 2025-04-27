namespace :db do
  desc "Backup the database"
  task backup: :environment do
    system("scripts\\backup_db.bat")
  end

  desc "Restore the database from a backup"
  task :restore, [:backup_file] => :environment do |t, args|
    if args[:backup_file].nil?
      puts "Please specify a backup file: rake db:restore[path/to/backup.sql]"
      exit 1
    end
    system("scripts\\restore_db.bat #{args[:backup_file]}")
  end
end 