class Token < ActiveRecord::Base
  # belongs_to :player, primary_key: "uid", foreign_key: "uid"  #TODO

  validates :uid, :token, presence: true, uniqueness: true
end
