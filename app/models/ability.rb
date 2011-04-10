class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
    user ||= User.new # guest user (not logged in)
    if user.role.blank?
      can :read, Company
    end
    if user.role? :employee
      can :manage, Task do |task|
         task.user_id == user.id || task.assigned_to == user.id || user.company_ids.include?(task.assigned_company)
      end
      can :dashboard, Company
      can [:customer_policies, :customer_orders, :customer_addresses, :customer_comments], Customer
      can [:create, :update, :all_services_popup], Order, :closed => false
      can [:check_if_printable, :print_order], Order
      can :add_to_order, :all
      can [:create, :update, :destroy], Item, :closed => false
      can [:verify_current_user, :dashboard], User
      can :read, [Company, Category, Service, Vendor, Order, Item]
      can [:read, :update], User do |current_user|
        user.id == current_user.id
      end
      can [:read, :create], [InsurancePolicy, Endorsement]
      can [:create, :update, :my_customers, :read], [Customer, Address]
      can [:index, :store_reports, :policy_reports, :render_my_partial], Report
    end
    if user.role? :manager
      can [:read, :update], User, :role => ["employee", "manager"]
      can :create, User
      can [:create, :update], [Service, Vendor]
      can :update, InsurancePolicy
    end
    if user.role? :admin
      can :manage, :all
    end
    

    
    
   # user ||= User.new # guest user (not logged in)
   # if user.role == "admin"
   #   # Only Admin can create Users
   #   can :manage, :all
   # elsif user.role == "manager"
   #   can :update, [User, Customer, Address]
   # else
   #   can [:create, :update], [User, Company, Customer, Address]
   #   can :read, :all
   # end
  end
end
