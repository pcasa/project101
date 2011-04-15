class Task < ActiveRecord::Base
  acts_as_paranoid
  
  # task.only_deleted # retrieves the deleted records
  # task.with_deleted # retrieves all records, deleted or not
  
  # To Really delete a record
  # task.destroy!
  # Task.delete_all!(conditions)
  
  belongs_to :company, :class_name => "Company", :foreign_key => :assigned_company
  belongs_to  :user
  belongs_to :insurancy_policy
  belongs_to  :assignee, :class_name => "User", :foreign_key => :assigned_to
  belongs_to  :completor, :class_name => "User", :foreign_key => :completed_by
  belongs_to  :asset, :polymorphic => true
  has_one :comment, :as => :commentable, :dependent => :destroy
  
    attr_accessible :user_id, :assigned_to, :completed_by, :assigned_company, :name, :asset_id, :asset_type, :category, :due_at, :deleted_at, :mark_as_completed, :current_tasks_for, :comment_attributes
      
    
    accepts_nested_attributes_for :comment, :allow_destroy => true, :reject_if => proc { |a| a[:content].blank? }
    
    
    before_update :check_if_notes, :if_user_assigned_delete_task
    before_save :if_user_assigned_delete_task
    validates_presence_of :due_at, :message => "can't be blank"
    
    
   
    
    # Status based scopes to be combined with the due date and completion time.
    scope :pending,       where("completed_by IS NULL").order("due_at, id")
    scope :assigned,      where("completed_by IS NULL AND assigned_to IS NOT NULL").order("due_at, id")
    scope :completed,     where("completed_by IS NOT NULL").order("completed_by DESC")
    
    # Due date scopes.
    scope :overdue, lambda { where("due_at IS NOT NULL AND due_at < ?", Time.now.midnight).order("due_at ASC")}
    scope :due_today,     lambda { where("due_at >= ? AND due_at < ?", Time.now.midnight, Time.now.midnight.tomorrow).order("due_at ASC")}
    scope :due_tomorrow,  lambda { where("due_at >= ? AND due_at < ?", Time.now.midnight.tomorrow, Time.now.midnight.tomorrow + 1.day).order("due_at ASC")}
    scope :due_this_week, lambda { where("due_at >= ? AND due_at < ?", Time.now.midnight.tomorrow + 1.day, Time.now.next_week).order("due_at ASC") }
    scope :due_next_week, lambda { where("due_at >= ? AND due_at < ?", Time.now.next_week, Time.now.next_week.end_of_week + 1.day).order("due_at ASC")}
    scope :due_later,     lambda { where("due_at IS NULL OR due_at >= ?", Time.now.next_week.end_of_week + 1.day).order("due_at ASC")}

    # Completion time scopes.
    scope :completed_today,      lambda { where("completed_at >= ? AND completed_at < ?", Time.now.midnight, Time.now.midnight.tomorrow)}
    scope :completed_yesterday,  lambda { where("completed_at >= ? AND completed_at < ?", Time.now.midnight.yesterday, Time.now.midnight)}
    scope :completed_this_week,  lambda { where("completed_at >= ? AND completed_at < ?", Time.now.beginning_of_week , Time.now.midnight.yesterday)}
    scope :completed_last_week,  lambda { where("completed_at >= ? AND completed_at < ?", Time.now.beginning_of_week - 7.days, Time.now.beginning_of_week)}
    scope :completed_this_month, lambda { where("completed_at >= ? AND completed_at < ?", Time.now.beginning_of_month, Time.now.beginning_of_week - 7.days)}
    scope :completed_last_month, lambda { where("completed_at >= ? AND completed_at < ?", (Time.now.beginning_of_month - 1.day).beginning_of_month, Time.now.beginning_of_month)}
    
    
    
    CATEGORY = %w[call email follow_up money]
    
    
    
    def mark_as_completed(user_id)
      self.update_attributes(:completed_by => user_id, :deleted_at => Time.now)
    end
    
    def mark_completed_and_msg(user_id, msg)
      if comment.blank?
        Comment.create!(:commentable_type => self.class, :commentable_id => self.id, :content => msg )
      else
        comment.update_attribute(:content, msg)
      end
      self.update_attributes(:completed_by => user_id, :deleted_at => Time.now)
    end
    
    def check_if_notes
      if self.comment.blank? || self.comment.content.blank? || self.comment.content.scan(/[\w-]+/).size <= 2
        saved = false
        self.comment.errors[:content] << "You must have a comment and more than 3 words."
        raise ActiveRecord::Rollback
      end
    end
    
    def completed?
      !completed_by.blank?
    end
    
    def if_user_assigned_delete_task
      if completed?
        if deleted_at.blank?
          self.update_attribute(:deleted_at, Time.now)
        end
      end
    end
    
    
end

    
