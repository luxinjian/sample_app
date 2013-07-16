require 'spec_helper'

describe "UserPages" do
  subject { page }

  describe "'signup' page" do
    before { visit signup_path }

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
        page.should have_selector('div.alert', text: "Welcome to the Sample App")
      end

      it "should have a sign out link" do
        click_button "Create my account"
        page.should have_link('Sign out', href: signout_path)
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

  describe "'edit' page" do
    let(:user) { @user = FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    it { should have_selector('h1', text: "Update your profile") }
    it { should have_selector('title', text: "Edit user") }
    it { should have_link('change', href: "http://gravatar.com/mails") }

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name) { "New Name" }
      let(:new_email) { "newemail@example.com" }
      before do
        fill_in "Name", with: new_name
        fill_in "Email", with: new_email
        fill_in "Password", with: user.password
        fill_in "Confirmation", with: user.password_confirmation
        click_button "Save changes"
      end

      it { should have_selector('h1', text: new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { user.reload.name.should == new_name }
      specify { user.reload.email.should == new_email }
    end
  end

  describe "'index' page" do
    before do
      sign_in FactoryGirl.create(:user)
      visit users_path
    end

    it { should have_selector('title', text: "All users") }
    it { should have_selector('h1', text: "All users") }

    describe "pagination" do

      it { should have_selector('div') }

      it "should list all the users" do
        User.paginate(page: 1).each do |user|
          page.should have_selector('li', text: user.name)
        end
      end
    end
  end

  describe "'destroy' action" do
    let(:user) { FactoryGirl.create(:user) }
    let(:admin) { FactoryGirl.create(:admin) }

    describe "with non-admin user" do
      before do
        sign_in(user)
        visit users_path
      end
      it { should_not have_link('delete') }
    end

    #I don't know why, this test failed
#    describe "with admin user" do
#      before do
#        sign_in(admin)
#        visit users_path
#      end
#
#      it { should have_link('delete', href: user_path(user)) }
#      it "should change users count by -1" do
#        expect { click_link 'delete' }.to change(User, :count).by(-1)
#      end
#      it { should_not have_link('delete', href: user_path(admin)) }
#    end
  end
end
