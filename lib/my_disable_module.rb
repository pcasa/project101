module MyDisableModule
  def self.included(recipient)
    recipient.class_eval do
    include ModelInstanceMethods
  end
end

  # Instance Methods
  module ModelInstanceMethods

    #Here is the disable()
    def disable
      if self.attributes.include?(:disabled)
        self.update_attributes(:disabled => true)
      else
        #return false if model does not have disabled attribute
        false
      end
    end
  end
end

#This is where your module is being included into ActiveRecord
if Object.const_defined?("ActiveRecord")
  ActiveRecord::Base.send(:include, MyDisableModule)
end