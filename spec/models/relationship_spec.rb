require 'spec_helper'

describe Relationship do
  let(:follower) { FactoryGirl.create(:user) }
  let(:followed) { FactoryGirl.create(:user) }
  let(:relationship) { follower.relationships.build(followed_id: followed.id) }

  subject { relationship }

  it { should be_valid }
  it { should respond_to(:follower) }
  it { should respond_to(:followed) }

  describe "attribute accessible" do

    it "should not allow to access follower_id attribute" do
      expect do
        Relationship.new(follower_id: follower.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end

    describe "follower method" do
      its(:follower) { should == follower }
      its(:followed) { should == followed }
    end

    describe "when follower_id is not present" do
      before { relationship.follower_id = nil }
      it { should_not be_valid }
    end

    describe "when followed_id is not present" do
      before { relationship.followed_id = nil }
      it { should_not be_valid }
    end
  end
end
