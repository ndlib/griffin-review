class DevelopmentLoginController < ApplicationController


  def login

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

end
