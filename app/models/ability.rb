class Ability
  include CanCan::Ability

  def initialize(user)
    # :manage = [:read, :create, :update, :destroy]
    # You can't use :read for array of instances, so adding :read_multiple

    user ||= User.new

    # :read_multiple checks each object of any array of models against
    # the :read ability for that model.
    can :read_multiple, Array do |array|
      array.all? { |o| can?(:read, o) }
    end

    # Can manage jobs that belong to them
    can :manage, Job, user_id: user.id

    #if user.admin?
      #can :manage, :all
    #elsif user.manager?
      #can :manage, :all
      #cannot :manage, User
      #cannot :manage, Photo
      #cannot :manage, RFI
      #cannot :manage, ASI
    #elsif user.viewer?
      #can :manage, ShareLink
      #can :read, Job
      #can :update, Share
      #can :destroy, Share
      #can :create, Share
      #can :read, Submittal
      #can :create, Submittal
      #can :read, RFI
      #can :create, RFI
      #can :read, ASI
      #can :create, ASI
    #end
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
