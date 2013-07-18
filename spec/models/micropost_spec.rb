require 'spec_helper'

describe Micropost do

  let(:user) { FactoryGirl.create(:user) }
  before { @micropost = user.microposts.build(content: "Valid content") }

  subject { @micropost }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  its(:user) { should == user }

  it { should be_valid }

  describe "validation" do

    describe "user_id should be present" do
      before { @micropost.user_id = nil }
      it { should_not be_valid }
    end

    describe "content should be present" do
      before { @micropost.content = nil }
      it { should_not be_valid }
    end

    describe "content should not be too long" do
      before { @micropost.content = "a" * 141 }
      it { should_not be_valid }
    end
  end

  describe "accessible attribute" do
    it "should not allow create instance by new method" do
      expect do
        Micropost.new(content: "Valid content", user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end
end
