require 'devise/strategies/base'
require 'net/http'
require 'uri'

#helper method for removing the invite token from the request.uri
#and preventing circular redirects
 def uri_remove_param(uri, params = nil)
   return uri unless params
   params = Array(params)
   uri_parsed = URI.parse(uri)
   return uri unless uri_parsed.query
   escaped = uri_parsed.query.grep(/&amp;/).size > 0
   new_params = uri_parsed.query.gsub(/&amp;/, '&').split('&').reject { |q| params.include?(q.split('=').first) }
   uri = uri.split('?').first
   amp = escaped ? '&amp;' : '&'
   "#{uri}?#{new_params.join(amp)}"
 end

module Devise
  module Strategies
    class CasAuthenticatable < Base
      # True if the mapping supports authenticate_with_cas_ticket.
      def valid?        
         params[:invitation_token] or ( mapping.to.respond_to?(:authenticate_with_cas_ticket) && params[:ticket])
      end
      
      # Try to authenticate a user using the CAS ticket passed in params.
      # If the ticket is valid and the model's authenticate_with_cas_ticket method
      # returns a user, then return success.  If the ticket is invalid, then either
      # fail (if we're just returning from the CAS server, based on the referrer)
      # or attempt to redirect to the CAS server's login URL.
      def authenticate!
        redirect_url = uri_remove_param(request.url, 'invitation_token')
        unless params[:invitation_token].nil?
          return redirect!("#{::Devise.cas_base_url}/invite?invitation_token=#{params[:invitation_token]}&service=#{redirect_url}/users/service&redirect=#{redirect_url}")
        end

        ticket = read_ticket(params)
        if ticket
          if resource = mapping.to.authenticate_with_cas_ticket(ticket)
            success!(resource)
          elsif ticket.is_valid?
              logger.debug "="*30
              logger.debug ticket.response.user[:ido_id]
              logger.debug "="*30
            redirect!(::Devise.cas_unregistered_url(request.url, mapping), :ido_id => ticket.response.user)
            #fail!("The user #{ticket.response.user} is not registered with this site.  Please use a different account.")
          else
            fail!(:invalid)
          end
        else
          fail!(:invalid)
        end
      end
      
      protected
      
      def read_ticket(params)
        ticket = params[:ticket]
        return nil unless ticket
        
        service_url = ::Devise.cas_service_url(request.url, mapping)
        if ticket =~ /^PT-/
          ::CASClient::ProxyTicket.new(ticket, service_url, params[:renew])
        else
          ::CASClient::ServiceTicket.new(ticket, service_url, params[:renew])
        end
      end
    end
  end
end

Warden::Strategies.add(:bushido_authenticatable, Devise::Strategies::CasAuthenticatable)
