require 'spec_helper'

describe User do

  before (:each) do
    @attr = { :name => "Test User", 
              :email => "user@test.com",
              :password => "foobar",
              :password_confirmation => "foobar" }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  describe "name validations" do

    it "should require a name" do
      no_name_user = User.new(@attr.merge(:name => ""))
      no_name_user.should_not be_valid
    end

    it "should reject name that are too long" do
      long_name = "a" * 51
      long_name_user = User.new(@attr.merge(:name => long_name))
      long_name_user.should_not be_valid
    end

  end

  describe "email validations" do

    it "should require a email" do
      no_email_user = User.new(@attr.merge(:email => ""))
      no_email_user.should_not be_valid
    end

    it "should accept valid email addresses" do
      addresses = %w[user@foo.com USER_TWO@foo.bar.org first.last@foo.kr]
      addresses.each do |address|
        valid_email_user = User.new(@attr.merge(:email => address))
        valid_email_user.should be_valid
      end
    end

    it "should not accept invalid email addresses" do
      addresses = %w[user@foo,com USER_at_foo.org, first_name@foo.]
      addresses.each do |address|
        invalid_email_user = User.new(@attr.merge(:email => address))
        invalid_email_user.should_not be_valid 
      end
    end

    it "should reject duplicate email addresses" do
      User.create!(@attr)
      user_with_dup_email = User.new(@attr)
      user_with_dup_email.should_not be_valid
    end

    it "should reject email addresses identical up to case" do
      User.create!(@attr)
      upcased_email = @attr[:email].upcase
      user_with_up_case_email = User.new(@attr.merge(:email => upcased_email))
      user_with_up_case_email.should_not be_valid
    end

  end

  describe "password validations" do

    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "bad_pwd")).should_not be_valid
    end

    it "should reject short passwords" do
      short_pw = "a" * 5
      User.new(@attr.merge(:password => short_pw, :password_confirmation => short_pw)).
        should_not be_valid
    end

    it "shoud reject long passwords" do
      long_pw = "a" * 50
      User.new(@attr.merge(:password => long_pw, :password_confirmation => long_pw)).
        should_not be_valid
    end

  end

  describe "password encryption" do
  
    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end

    describe "has_valid_password? method" do

      it "should be true if the passwords match" do
        @user.has_valid_password?(@attr[:password]).should be_true
      end

      it "should be false if the passwords does not match" do
        @user.has_valid_password?("junkpassword").should be_false
      end

    end

    describe "authenticate method" do

      it "should return nil on invalid password" do
        no_user_found = User.authenticate(@attr[:email], "wrongpass")
        no_user_found.should be_nil
      end

      it "should return nil on email address does not exist in system" do
        no_user_found = User.authenticate("bademail@test.com", @attr[:password])
        no_user_found.should be_nil
      end

      it "should return the user with matching email and password" do
        matching_user = User.authenticate(@attr[:email], @attr[:password])
        matching_user.should == @user
      end

    end

  end

  describe "admin attribute" do
    before(:each) do
      @user = User.create!(@attr)
    end

    it "should respond to admin" do
      @user.should respond_to(:admin)
    end

    it "should not be an admin by default" do
      @user.should_not be_admin
    end

    it "should be convertible to an admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end
    
  end

end
