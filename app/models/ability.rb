class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new

    # note that all open item types inherit from OpenItem
    if user.has_role? :graduate_student
      can :read, External
      can [:create, :video_request_status], Request
    end

    if user.has_role? :faculty
      can :read, External
      can [:create, :video_request_status], Request
    end

    if user.has_role? :staff
      can :read, External
      can [:create, :video_request_status], Request
    end

    if user.has_role? :media_admin
      can [:manage ], [VideoWorkflow, Request, Video, MetadataAttribute, BasicMetadata, TechnicalMetadata]
      can [:all_metadata_attributes, :new_metadata_attribute, :create_metadata_attribute, :edit_metadata_attribute, :update_metadata_attribute, :destroy_metadata_attribute], [Admin]
      can :read, Role, :name => ['Media Admin', 'Staff', 'Faculty', 'Graduate Student']
      can [:read, :create, :update], User
    end

    if user.has_role? :reserves_admin
      can [:manage ], [Item, OpenItem, MetadataAttribute, BasicMetadata, TechnicalMetadata]
      can :read, Role, :name => ['Reserves Admin', 'Reserves Technician', 'Media Admin', 'Staff', 'Faculty', 'Graduate Student']
      can [:read, :create, :update], User
    end

    if user.has_role? :administrator
      can :manage, :all
    end

    if user.username == 'rfox2' || user.username == 'jhartzle'

      can :manage, :all
    end

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
