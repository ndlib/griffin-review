class Message < ActiveRecord::Base
  belongs_to :requests
  default_scope { order(created_at: :desc) }
end
