class DevelopmentLoginController < ApplicationController


  def login
    reserves

    if params[:username]
      u = User.where(:username => params[:username]).first

      if !u
        u = User.new(:username => params[:username])
        u.send(:fetch_attributes_from_ldap)
        u.save!
      end

      sign_in(u)

    end

  end


  protected

    def reserves
      @reserves ||= ReservesApp.new(current_user)
    end
end
