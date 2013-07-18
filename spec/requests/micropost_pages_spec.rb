require 'spec_helper'

describe "Micropost Pages" do

  describe "'create' page" do
    before do
      sign_in(FactoryGirl.create(:user))
      visit root_path
    end

    it "should have post button" do
      page.should have_link('view my profile')
    end

    describe "with invalid information" do

      it "should not change microposts count" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end
    end

    describe "with valid information" do
      before { fill_in "micropost_content", with: "valid content" }

      it "should change microposts count by 1" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end
    end
  end

  describe "micropost destruction" do
    before do
      user = FactoryGirl.create(:user)
      FactoryGirl.create(:micropost, user: user)
      sign_in user
    end

    it "should change microposts count by -1" do
      expect { click_link("delete") }.to change(Micropost, :count).by(-1)
    end
  end
end
