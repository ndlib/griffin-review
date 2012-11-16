Warden::Manager.before_logout do |user, auth, opts|
    auth.session[:viewed_modal] = nil
end
