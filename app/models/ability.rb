class Ability
  include CanCan::Ability

  # A list of actions to call super on in can?.
  GENERIC_CLASS_ACTIONS = [:upload]

  def can?(action, subject, *extra_args)
    # Typical functionality is to accept generic class calls since
    # they can't be checked due to lack of attrs. We want generic
    # classes to authorize to false.
    if subject.is_a?(Class)
      if GENERIC_CLASS_ACTIONS.include?(action)
        return super(action, subject, extra_args)
      else
        return false
      end
    else
      return super(action, subject, extra_args)
    end
  end

  def initialize(user)
    # :manage = [:read, :create, :update, :destroy]
    # You can't use :read for array of instances, so adding :read_multiple

    user ||= User.new

    # :manage returns true for all actions.  Not just CRUD actions.
    alias_action :create, :read, :update, :destroy, :to => :crud

    # :read_multiple checks each object of any array of models against
    # the :read ability for that model.
    can :read_multiple, Array do |array|
      array.all? { |o| can?(:read, o) }
    end

    # Can manage jobs that belong to them
    can :crud, Job, user_id: user.id

    # Can manage plans for jobs that belong to them
    can [:create, :update, :destroy], Plan, job: { user_id: user.id }

    # If we are given a Document, then we delegate to the
    # document_association permissions.
    can :download, Document do |document|
      can?(:download, document.document_association)
    end

    # Define document_association permissions.
    can :download, PlanDocument, plan: { job: { user_id: user.id } }

    # Only users with accounts can upload Documents.
    if !user.new_record?
      can :upload, Document
    end
  end
end
