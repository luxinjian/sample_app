require 'spec_helper'

describe "Authentication Pages" do
  subject { page }

  describe "signin page" do
    before { visit signin_path }

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
      it { should have_link('Settings', href: edit_user_path(user)) }
      it { should have_link('Users', href: users_path) }
    end
  end

  describe "authorization" do
    let(:user) { FactoryGirl.create(:user) }

    describe "with non-sign_in user" do

      describe "attempt to visit user's edit page before sign in" do
        before do
          visit edit_user_path(user)
          fill_in "Email", with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end

        describe "after sign in" do
          it { should have_selector('title', text: "Edit user") }
        end
      end

      describe "in the User's controller" do

        describe "visit the edit page" do
          before { visit edit_user_path(user) }
          it { should have_selector('h1', text: "Sign in") }
        end

        describe "submiting to the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end

        describe "as wrong user" do
          let(:wrong_user) { FactoryGirl.create(:user, email: "another@example.com") }
          before do
            sign_in(wrong_user)
          end

          describe "visit Users#edit page" do
            before { visit edit_user_path(user) }
            it { should_not have_selector('title', text: "Edit user") }
          end

          describe "submiting to Users update action" do
            before { put user_path(user) }
            specify { response.should redirect_to(root_path) }
          end
        end

        describe "visit the index page" do
          before { visit users_path }
          it { should have_selector('h1', text: "Sign in") }
        end

        describe "submiting to the destroy action" do
          before do
            sign_in user
            delete user_path(user)
          end
          specify { response.should redirect_to(root_path) }
        end

        describe "followers page" do
          before { visit followers_user_path(1) }

          it { should have_selector('title', text: "Sign in") }
        end

        describe "following page" do
          before { visit following_user_path(1) }

          it { should have_selector('title', text: "Sign in") }
        end
      end

      describe "in the Micropost's controller" do

        describe "submiting to Micropost create action" do
          before { post microposts_path, micropost: nil }
          specify { response.should redirect_to(signin_path) }
        end

        describe "submiting to Micropost destroy action" do
          let(:user) { FactoryGirl.create(:user) }
          let(:wrong_user) { FactoryGirl.create(:user) }
          let(:micropost) { FactoryGirl.create(:micropost, user: user) }

          describe "with non-sign_in user" do
            before { delete micropost_path(micropost) }
            specify { response.should redirect_to(signin_path) }
          end

          describe "with wrong user" do
            before do
              sign_in wrong_user
              delete micropost_path(micropost)
            end
            specify { response.should redirect_to(root_path) }
          end
        end
      end
    end

    describe "with sign_in user" do
      before { sign_in(FactoryGirl.create(:user)) }

      describe "when visit 'new' page" do
        before { visit signup_path }
        it { should_not have_selector('title', text: "Sign up") }
      end

      describe "when submiting to the create action" do
        before { post users_path, user: nil }
        specify { response.should redirect_to(root_path) }
      end
    end
  end
end
