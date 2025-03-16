namespace :maintenance do
  desc "Run all maintenance checks"
  task all: [:environment] do
    Rake::Task["maintenance:check_data_integrity"].invoke
    Rake::Task["maintenance:cleanup_orphaned_records"].invoke
    Rake::Task["maintenance:generate_health_report"].invoke
  end

  desc "Check data integrity"
  task check_data_integrity: :environment do
    puts "\n=== Checking Data Integrity ==="
    
    # Check for tasks with invalid completed_by references
    invalid_tasks = Task.where.not(completed_by: nil)
                       .where.not(completed_by: User.select(:id))
    if invalid_tasks.exists?
      puts "WARNING: Found #{invalid_tasks.count} tasks with invalid completed_by references"
      invalid_tasks.find_each do |task|
        puts "  - Task ##{task.id}: #{task.title}"
      end
    end

    # Check for tasks marked complete but without completed_at
    inconsistent_tasks = Task.where(completed: true, completed_at: nil)
    if inconsistent_tasks.exists?
      puts "WARNING: Found #{inconsistent_tasks.count} completed tasks without completed_at timestamp"
      inconsistent_tasks.find_each do |task|
        puts "  - Task ##{task.id}: #{task.title}"
      end
    end

    # Check for comments with invalid status
    invalid_comments = Comment.where.not(status: %w[open closed resolved])
    if invalid_comments.exists?
      puts "WARNING: Found #{invalid_comments.count} comments with invalid status"
      invalid_comments.find_each do |comment|
        puts "  - Comment ##{comment.id} on Task ##{comment.task_id}"
      end
    end
  end

  desc "Cleanup orphaned records"
  task cleanup_orphaned_records: :environment do
    puts "\n=== Cleaning Up Orphaned Records ==="
    
    ApplicationRecord.transaction do
      # Clean up orphaned comments
      orphaned_comments = Comment.where.not(task_id: Task.select(:id))
      if orphaned_comments.exists?
        count = orphaned_comments.count
        orphaned_comments.destroy_all
        puts "Deleted #{count} orphaned comments"
      end

      # Clean up unused tags
      unused_tags = Tag.left_joins(:tasks).where(tasks: { id: nil })
      if unused_tags.exists?
        count = unused_tags.count
        unused_tags.destroy_all
        puts "Deleted #{count} unused tags"
      end
    end
  end

  desc "Generate health report"
  task generate_health_report: :environment do
    puts "\n=== Generating Health Report ==="
    
    # Task statistics
    total_tasks = Task.count
    completed_tasks = Task.where(completed: true).count
    overdue_tasks = Task.overdue.count
    completion_rate = total_tasks.zero? ? 0 : (completed_tasks.to_f / total_tasks * 100).round(2)
    
    puts "Task Statistics:"
    puts "  - Total Tasks: #{total_tasks}"
    puts "  - Completed Tasks: #{completed_tasks} (#{completion_rate}%)"
    puts "  - Overdue Tasks: #{overdue_tasks}"
    
    # Comment statistics
    total_comments = Comment.count
    open_comments = Comment.unresolved.count
    resolved_comments = Comment.resolved.count
    
    puts "\nComment Statistics:"
    puts "  - Total Comments: #{total_comments}"
    puts "  - Open Comments: #{open_comments}"
    puts "  - Resolved Comments: #{resolved_comments}"
    
    # Performance metrics
    tasks_with_many_comments = Task.joins(:comments)
                                  .group('tasks.id')
                                  .having('COUNT(comments.id) > 10')
                                  .count
    
    puts "\nPerformance Metrics:"
    puts "  - Tasks with >10 comments: #{tasks_with_many_comments.count}"
    
    # Version history statistics
    version_count = PaperTrail::Version.count
    puts "\nAudit Trail Statistics:"
    puts "  - Total Changes Tracked: #{version_count}"
    puts "  - Changes in Last 24h: #{PaperTrail::Version.where('created_at > ?', 24.hours.ago).count}"
  end
end 