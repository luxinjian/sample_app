require 'spec_helper'

describe "UserPages" do

  describe "'signup' page" do
    before { visit signup_path }
    subject { page }

    it { should have_selector('h1', text: 'Sign up') }
    it { should have_selector('title', text: full_title('Sign up')) }

    describe "with invalid informations" do

      it "should not change users count" do
        expect { click_button "Create my account" }.not_to change(User, :count)
      end
    end

    describe "with valid informations" do
      before do
        fill_in "Name", with: "Example User"
        fill_in "Email", with: "example@user.com"
        fill_in "Password", with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should change users count by 1" do
        expect { click_button "Create my account" }.to change(User, :count).by(1)
      end

      it "should have an success message" do
        click_button "Create my account"
        #flash[:success].should =~ /welcome to the sample app/i
        page.should have_selector('div.alert', text: "Welcome to the Sample App")
      end
    end
  end

  describe "'show' page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }
    subject { page }

    it { should have_selector('h1', text: user.name) }
    it { should have_selector('title', text: user.name) }
  end
end
