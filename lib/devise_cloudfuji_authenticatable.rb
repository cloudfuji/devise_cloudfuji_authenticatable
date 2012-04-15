require File.expand_path(File.dirname(__FILE__)) + '/devise_cas_authenticatable'

module Devise
  def self.on_cloudfuji?
    return false if ENV['CLOUDFUJI_APP_KEY'].nil?
    true
  end
end
