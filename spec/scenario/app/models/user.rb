class User < ActiveRecord::Base
  devise :cloudfuji_authenticatable, :rememberable
end
