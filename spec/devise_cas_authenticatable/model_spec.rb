require "spec_helper"

describe Devise::Models::CloudfujiAuthenticatable do
  
  class ExampleAuth
    include Devise::Models::CloudfujiAuthenticatable
  end
  
  describe "authenticate_with_cas_ticket" do

    before :each do
      @ticket = Object.new
      @user = Object.new

      @ticket.should_receive(:user).and_return(@user)
      @ticket.should_receive(:has_been_validated?).and_return(true)
      @ticket.should_receive(:is_valid?).and_return(true)
      ::Devise.cas_create_user = true

      ExampleAuth.should_receive(:find_for_authentication).and_return(@user)
      @user.should_receive(:save)
    end
    
    it "should call the cloudfuji_extra_attributes method if it's defined on the devise resource" do
      @ticket.should_receive(:extra_attributes)
      @user.should_receive(:cloudfuji_extra_attributes)
      ExampleAuth.authenticate_with_cas_ticket(@ticket)
    end

    it "should *not* call the cloudfuji_extra_attributes method if it's *not* defined on the devise resource" do

      @user.should_receive(:respond_to?).and_return(false)      
      @user.should_not_receive(:cloudfuji_extra_attributes)

      ExampleAuth.authenticate_with_cas_ticket(@ticket)
    end
    
  end
end
