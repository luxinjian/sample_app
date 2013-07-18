# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe User do

  before { @user = User.new(name: "Example User",
                            email: "user@example.com",
                            password: "foobar",
                            password_confirmation: "foobar") }
  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:admin) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:microposts) }
  it { should respond_to(:feed) }

  it { should be_valid }
  it { should_not be_admin }

  describe "when admin attribute is set to 'true'" do
    before { @user.toggle!(:admin) }
    it { should be_admin }
  end

  describe "when name is no present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when email is no present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when password is no present" do
    before { @user.password = @user.password_confirmation = " " }
    it { should_not be_valid }
  end

  describe "when password is too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should_not be_valid }
  end

  describe "when  email is invalid" do
    it "should be invalid" do
      invalids = %w{ user@example.@com user@example@mail.com user@example }
      invalids.each do |invalid|
        @user.email = invalid
        @user.should_not be_valid
      end
    end
  end

  describe "when  email is valid" do
    it "should be valid" do
      valids = %w{ user@mail.com user-example@mail.com test.user@example.com }
      valids.each do |valid|
        @user.email = valid
        @user.should be_valid
      end
    end
  end

  describe "when email is duplicated" do
    before do
      another = @user.dup
      another.save
    end
    it { should_not be_valid }
  end

  describe "when email is duplicated with case-sensitive" do
    before do
      another = @user.dup
      another.email = @user.email.upcase
      another.save
    end
    it { should_not be_valid }
  end

  describe "when password is mismatch" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "when password confirmation is nil" do
    before { @user.password_confirmation = nil }
    it { should_not be_valid }
  end

  describe "when authenticate catch match and mismatch password" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }

    it { should == found_user.authenticate(@user.password) }

    describe "with invalid password" do
      let(:user_with_invalid_password) { found_user.authenticate("invalid") }
      it { should_not == user_with_invalid_password }
      specify { user_with_invalid_password.should be_false }
    end
  end

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

  describe "micropost association" do

    describe "micropost order" do

      before { @user.save }
      let!(:mp1) { FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago) }
      let!(:mp2) { FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago) }

      it "should have right order" do
        @user.microposts.should == [mp2, mp1]
      end
    end

    it "should not exist after associated user destroyed" do
      microposts = @user.microposts
      @user.destroy
      microposts.each do |m|
        Micropost.find_by_id(m.id).should be_nil
      end
    end
  end

  describe "feed" do
    before { @user.save }
    let(:mp) { FactoryGirl.create(:micropost, user: @user) }
    let(:mp_with_other_user) do
      FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
    end

      its(:feed) { should include(mp) }

      its(:feed) { should_not include(mp_with_other_user) }
  end
end
