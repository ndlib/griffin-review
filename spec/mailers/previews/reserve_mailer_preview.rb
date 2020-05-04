class ReserveMailerPreview < ActionMailer::Preview
  def published_request_notifier
    info = {"rdought1"=>{"email"=>"rdought1@nd.edu", "display_name"=>"Ryan Doughty", "requests"=>["Offense, Defense, and the Causes of War"]}}
    ReserveMailer.published_request_notifier(info).deliver_now
  end
end