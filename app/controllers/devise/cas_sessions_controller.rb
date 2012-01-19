class Devise::CasSessionsController < Devise::SessionsController

  def new
    redirect_to(cas_login_url) unless returning_from_cas?
  end

  def service
    warden.authenticate!(:scope => resource_name)
    return redirect_to params[:redirect] if params[:redirect]
    return redirect_to after_sign_in_path_for(resource_name)
  end

  def unregistered
  end

  def destroy
    # Delete the ticket->session ID mapping if one exists for this session
    if ticket = session['cas_last_valid_ticket']
      ::DeviseCasAuthenticatable::SingleSignOut::Strategies.current_strategy.delete_session_index(ticket)
    end

    # if :cas_create_user is false a CAS session might be open but not signed_in
    # in such case we destroy the session here
    if signed_in?(resource_name)
      sign_out(resource_name)
    else
      reset_session
    end
    redirect_to(::Devise.cas_client.logout_url)
  end

  def single_sign_out
    if ::Devise.cas_enable_single_sign_out
      session_index = read_session_index
      if session_index
        logger.info "Intercepted single-sign-out request for CAS session #{session_index}."
        session_id = ::DeviseCasAuthenticatable::SingleSignOut::Strategies.current_strategy.find_session_id_by_index(session_index)
        destroy_cas_session(session_id, session_index) if session_id
      else
        logger.warn "Ignoring CAS single-sign-out request as no session index could be parsed from the parameters."
      end
    else
      logger.warn "Ignoring CAS single-sign-out request as feature is not currently enabled."
    end

    render :nothing => true
  end

  protected

  def read_session_index
    if request.headers['CONTENT_TYPE'] =~ %r{^multipart/}
      false
    elsif request.post? && params['logoutRequest'] =~
        %r{^<samlp:LogoutRequest.*?<samlp:SessionIndex>(.*)</samlp:SessionIndex>}m
      $~[1]
    else
      false
    end
  end

  def destroy_cas_session(session_id, session_index)
    if session_store && session_store.new.respond_to?(:destroy)
      if session_store.respond_to? :find_by_session_id
        user_session = session_store.find_by_session_id(session_id)
      elsif session_store.respond_to? :find
        user_session = session_store.find(session_id)
      end
      user_session.destroy if user_session
    else
      logger.info "A single sign out request was received for ticket #{session_index} but the Rails session_store is not a type supported for single-sign-out by devise_cas_authenticatable."
    end
    ::DeviseCasAuthenticatable::SingleSignOut::Strategies.current_strategy.delete_session_index(session_index)
  end
  
  def session_store
    @session_store ||= (Rails.respond_to?(:application) && Rails.application.config.session_store.session_class)
  end

  def returning_from_cas?
    params[:ticket] || request.referer =~ /^#{::Devise.cas_client.cas_base_url}/
  end

  def cas_return_to_url
    resource_or_scope = ::Devise.mappings.keys.first rescue 'user'
    session["#{resource_or_scope}_return_to"].nil? ? '/' : session["#{resource_or_scope}_return_to"].to_s
  end

  def cas_login_url
    login_url = ::Devise.cas_client.add_service_to_login_url(::Devise.cas_service_url(request.url, devise_mapping))

    redirect_url = "&redirect=#{cas_return_to_url}"

    return "#{login_url}#{redirect_url}"
  end
  helper_method :cas_login_url
end
