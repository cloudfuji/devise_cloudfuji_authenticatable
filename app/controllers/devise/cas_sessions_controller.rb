class Devise::CasSessionsController < Devise::SessionsController
  include Devise::CasControllerActions

  helper_method :cas_login_url
end
