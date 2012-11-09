class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new

    # note that all open item types inherit from OpenItem
    if user.has_role? :administrator
      can :manage, [OpenItem, Group, Role, Request, Semester, VideoWorkflow, User, Admin, Item, Video]
      can [:show_all_semesters, :show_proximate_semesters, :index_semester, :new_semester, :read, :edit_semester, :create_semester, :update_semester, :show_semester, :user_info, :all_metadata_attributes], :all
    end

    if user.has_role? :reserves_admin
      can [:manage ], [Item, OpenItem, MetadataAttribute, BasicMetadata, TechnicalMetadata]
      can :read, User
    end

    if user.has_role? :media_admin
      can [:manage ], [VideoWorkflow, Video, MetadataAttribute, BasicMetadata, TechnicalMetadata]
      can [:all_metadata_attributes, :new_metadata_attribute, :create_metadata_attribute, :edit_metadata_attribute, :update_metadata_attribute, :destroy_metadata_attribute], [Admin]
      can :read, User
    end

    if user.has_role? :faculty
      can :read, External
      can [:create, :video_request_status], Request
    end

    if user.has_role? :graduate_student
      can :read, External
      can [:create, :video_request_status], Request
    end

    if user.has_role? :staff
      can :read, External
      can [:create, :video_request_status], Request
    end

    if user.username == 'rfox2'
      can :manage, User
    end

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
  end
end
