namespace :data_integrity do
  desc "Run all data integrity checks"
  task check_all: :environment do
    Rake::Task["data_integrity:check_orphans"].invoke
    Rake::Task["data_integrity:check_inconsistencies"].invoke
    Rake::Task["data_integrity:clean_unused_tags"].invoke
  end

  desc "Check for orphaned records"
  task check_orphans: :environment do
    puts "Checking for orphaned records..."
    
    # Check for tasks without valid projects
    orphaned_tasks = Task.left_joins(:project)
                        .where(projects: { id: nil })
    
    # Check for comments without valid tasks
    orphaned_comments = Comment.left_joins(:task)
                              .where(tasks: { id: nil })
    
    # Check for tasks without valid users
    unowned_tasks = Task.left_joins(:user)
                       .where(users: { id: nil })
    
    if orphaned_tasks.exists? || orphaned_comments.exists? || unowned_tasks.exists?
      puts "Found data inconsistencies:"
      puts "- #{orphaned_tasks.count} orphaned tasks" if orphaned_tasks.exists?
      puts "- #{orphaned_comments.count} orphaned comments" if orphaned_comments.exists?
      puts "- #{unowned_tasks.count} unowned tasks" if unowned_tasks.exists?
      
      # Log to application logger
      Rails.logger.error "Data integrity issues found at #{Time.current}"
      # You could also send an email to administrators here
    else
      puts "No orphaned records found."
    end
  end

  desc "Check for data inconsistencies"
  task check_inconsistencies: :environment do
    puts "Checking for data inconsistencies..."
    
    # Check for tasks marked complete but with incomplete subtasks
    inconsistent_tasks = Task.where(completed: true)
                            .joins(:comments)
                            .where("comments.resolved = ?", false)
    
    # Check for projects marked complete but with incomplete tasks
    inconsistent_projects = Project.where(status: 'completed')
                                 .joins(:tasks)
                                 .where(tasks: { completed: false })
    
    if inconsistent_tasks.exists? || inconsistent_projects.exists?
      puts "Found status inconsistencies:"
      puts "- #{inconsistent_tasks.count} completed tasks with unresolved comments"
      puts "- #{inconsistent_projects.count} completed projects with incomplete tasks"
    else
      puts "No status inconsistencies found."
    end
  end

  desc "Clean up unused tags"
  task clean_unused_tags: :environment do
    puts "Cleaning up unused tags..."
    
    unused_tags = Tag.left_joins(:tasks)
                    .where(tasks: { id: nil })
    count = unused_tags.count
    
    if count > 0
      unused_tags.destroy_all
      puts "Removed #{count} unused tags."
    else
      puts "No unused tags found."
    end
  end

  desc "Generate data integrity report"
  task report: :environment do
    puts "Generating data integrity report..."
    
    report = {
      total_projects: Project.count,
      total_tasks: Task.count,
      total_comments: Comment.count,
      total_tags: Tag.count,
      active_tasks: Task.active.count,
      overdue_tasks: Task.overdue.count,
      completion_rate: (Task.where(completed: true).count.to_f / Task.count * 100).round(2)
    }
    
    puts "\nData Integrity Report"
    puts "-------------------"
    report.each do |key, value|
      puts "#{key.to_s.humanize}: #{value}"
    end
  end
end 