class Task < ActiveRecord::Base
  acts_as_paranoid
  
  # task.only_deleted # retrieves the deleted records
  # task.with_deleted # retrieves all records, deleted or not
  
  # To Really delete a record
  # task.destroy!
  # Task.delete_all!(conditions)
  
  belongs_to :company, :class_name => "Company", :foreign_key => :assigned_company
  belongs_to  :user
  belongs_to  :assignee, :class_name => "User", :foreign_key => :assigned_to
  belongs_to  :completor, :class_name => "User", :foreign_key => :completed_by
  belongs_to  :asset, :polymorphic => true
  
    attr_accessible :user_id, :assigned_to, :completed_by, :assigned_company, :name, :asset_id, :asset_type, :category, :due_at, :deleted_at
    
    # Status based scopes to be combined with the due date and completion time.
    scope :pending,       where("completed_at IS NULL").order("due_at, id")
    scope :assigned,      where("completed_at IS NULL AND assigned_to IS NOT NULL").order("due_at, id")
    scope :completed,     where("completed_at IS NOT NULL").order("completed_at DESC")
    
    # Due date scopes.
    scope :overdue, lambda { where("due_at IS NOT NULL AND due_at < ?", Time.now.midnight).order("id DESC")}
    scope :due_today,     lambda { where("due_at >= ? AND due_at < ?", Time.now.midnight, Time.now.midnight.tomorrow).order("id DESC")}
    scope :due_tomorrow,  lambda { where("due_at >= ? AND due_at < ?", Time.now.midnight.tomorrow, Time.now.midnight.tomorrow + 1.day).order("id DESC")}
    scope :due_this_week, lambda { where("due_at >= ? AND due_at < ?", Time.now.midnight.tomorrow + 1.day, Time.now.next_week).order("id DESC") }
    scope :due_next_week, lambda { where("due_at >= ? AND due_at < ?", Time.now.next_week, Time.now.next_week.end_of_week + 1.day).order("id DESC")}
    scope :due_later,     lambda { where("(due_at IS NULL AND bucket = 'due_later') OR due_at >= ?", Time.now.next_week.end_of_week + 1.day).order("id DESC")}

    # Completion time scopes.
    scope :completed_today,      lambda { where("completed_at >= ? AND completed_at < ?", Time.now.midnight, Time.now.midnight.tomorrow)}
    scope :completed_yesterday,  lambda { where("completed_at >= ? AND completed_at < ?", Time.now.midnight.yesterday, Time.now.midnight)}
    scope :completed_this_week,  lambda { where("completed_at >= ? AND completed_at < ?", Time.now.beginning_of_week , Time.now.midnight.yesterday)}
    scope :completed_last_week,  lambda { where("completed_at >= ? AND completed_at < ?", Time.now.beginning_of_week - 7.days, Time.now.beginning_of_week)}
    scope :completed_this_month, lambda { where("completed_at >= ? AND completed_at < ?", Time.now.beginning_of_month, Time.now.beginning_of_week - 7.days)}
    scope :completed_last_month, lambda { where("completed_at >= ? AND completed_at < ?", (Time.now.beginning_of_month - 1.day).beginning_of_month, Time.now.beginning_of_month)}
end

    CATEGORY = %w[call email follow_up money]
