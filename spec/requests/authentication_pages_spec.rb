require 'spec_helper'

describe "Authentication Pages" do

  describe "signin page" do
    before { visit signin_path }
    subject { page }

    it { should have_selector('h1', text: "Sign in") }
    it { should have_selector('title', text: "Sign in") }

    describe "with invalid email/password combination" do
      before { click_button "Sign in" }
      it { should have_selector('div.alert.alert-error',
                                text: "Invalid") }

      describe "after visit another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error',
                                text: "Invalid") }
      end
    end

    describe "with valid email/password combination" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email", with: user.email
        fill_in "Password", with: user.password
        click_button "Sign in"
      end

      it { should have_selector('h1', text: user.name) }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }
    end
  end
end
