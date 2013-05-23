require 'spec_helper'

describe User do

  describe "validates data" do
    subject { User.new(@valid_attributes)}

    it { should     accept_values_for(:email, "john@example.com", "lambda@gusiev.com") }
    it { should_not accept_values_for(:email, "invalid", nil, "a@b", "john@.com") }
  end

  it "can authenticate with right mail + password" do
    u1 = User.create!( :name => "dummy", :email => "foo@bar.com", :password => "geheim" )
    u2 = User.authenticate( "foo@bar.com", "geheim" )
    u2.should_not be_nil
    u1.id.should eql(u2.id)
  end

  it "cannot authenticate with wrong password" do
    u1 = User.create!( :name => "dummy", :email => "foo@bar.com", :password => "geheim" )
    u2 = User.authenticate( "foo@bar.com", "falsch" )
    u2.should be_nil
  end

  it "should not save password as plain text" do
    password = "secretpassword"
    u = User.create!( :name => "dummy", :email => "foo@bar.com", :password => password )

    find_u = User.find_by_email("foo@bar.com")
    find_u.password.should_not eql(password)
    find_u.password.should be_nil
  end

  it "should save password salted and hashed" do
    password = "secretpassword"
    User.create!( :name => "dummy", :email => "foo@bar.com", :password => password )

    find_u = User.find_by_email("foo@bar.com")

    User.find_by_email("foo@bar.com").password_hash.should_not eql(password)
    User.find_by_email("foo@bar.com").password_hash.should eql(BCrypt::Engine.hash_secret(password, find_u.password_salt))
  end



end
