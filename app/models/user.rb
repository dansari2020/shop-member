class User < ActiveRecord::Base
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  # devise :omniauthable, omniauth_providers: %i[doorkeeper]

  def self.from_oauth(auth)
    where(email: auth["email"]).first_or_initialize do |user|
      user.password = Devise.friendly_token[0, 20]
      user.name = [auth["first_name"], auth["last_name"]].join(" ")
      user.save
    end
  end

  def update_credentials(token, refresh_token = "")
    
    update(
      doorkeeper_access_token: token,
      doorkeeper_refresh_token: refresh_token
    )
  end
end
