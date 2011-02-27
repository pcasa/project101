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
      can :read, [User, Company, Category, Customer, Service, ServiceGroup]
      can :dashboard, User
      can [:create, :update], [Customer, Address]
    end
    if user.role? :manager
      can :create, User
      can [:create, :update], [Service, ServiceGroup]
      can :manage, SpecialService
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
