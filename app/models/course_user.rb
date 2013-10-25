class CourseUser

  attr_accessor :user, :course, :source, :role

  delegate :id, :username, :display_name, :first_name, :last_name, :email, to: :user


  def initialize(user, course, role, source)
    @user = user
    @role = role
    @source = source
    @course = course


    validate_inputs!
  end


  def self.netid_factory(netid, course, role, source)

    if !netid.nil?
      u = User.username(netid).first || User.new(username: netid)

      if u.new_record?
        u.save!
      end
    else
      u = User.new(username: "", display_name: "")
    end

    self.new(u, course, role, source)
  end


  def can_be_deleted?
    @source == 'exception'
  end


  private

    def validate_inputs!
      validate_source!
      validate_role!
    end


    def validate_role!
      if !['instructor', 'enrollment'].include?(@role.downcase)
        raise "Invalid role, #{@role}"
      end
    end


    def validate_source!
      if !['banner', 'exception'].include?(@source.downcase)
        raise "Invalid source, #{@source}"
      end
    end
end
