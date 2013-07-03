class Masquerade


  def initialize(controller)
    @controller = controller
  end


  def start!(username)
    if !masquerading?
      user = find_or_create_user(username)
      if !user
        return false
      end

      @controller.session[:masquerading] = @controller.current_user.id
      @controller.sign_in(user)
      @masquerading_user = user
    end

    return true
  end


  def cancel!
    if masquerading?
      @controller.sign_in(main_user)
      @controller.session[:masquerading] = false
    end
  end


  def masquerading?
    @controller.session[:masquerading]
  end


  def masquerading_user
    if masquerading?
      @masquerading_user ||= @controller.current_user
    else
      nil
    end
  end


  def main_user
    if masquerading?
      @original_user ||= User.find(@controller.session[:masquerading])
    else
      @original_user ||= @controller.current_user
    end
  end


  private

    def find_or_create_user(username)
      begin
        u = User.where(:username => username).first

        if !u
          u = User.new(:username => username)
          u.send(:fetch_attributes_from_ldap)
          u.save!
        end

        u
      rescue ActiveRecord::RecordInvalid
        false
      end
    end


end
