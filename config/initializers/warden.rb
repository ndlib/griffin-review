Warden::Manager.before_logout do |user, auth, opts|
  unless user.blank?
    if user.active_for_authentication?
      auth.raw_session[:viewed_modal] = 'new'
    end
  end
end
