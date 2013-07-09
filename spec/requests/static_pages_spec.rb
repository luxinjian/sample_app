require'spec_helper'

describe "StaticPages" do
 let(:base_title) { "Ruby on Rails Tutorial Sample App | " }

 describe "'home' page" do

   it "should have the content 'Sample App'" do
     visit '/static_pages/home'
     page.should have_content('Sample App')
   end

   it "should have right title" do
     visit '/static_pages/home'
     page.should have_selector('title',
                               text: "#{base_title}Home")
   end
 end

 describe "'help' page" do

   it "should have the content 'Help'" do
     visit '/static_pages/help'
     page.should have_content('Help')
   end

   it "should have right title" do
     visit '/static_pages/help'
     page.should have_selector('title',
                               text: "#{base_title}Help")
   end
 end

 describe "'about' page" do

   it "should have the content 'About Us'" do
     visit '/static_pages/about'
     page.should have_content('About Us')
   end

   it "should have right title" do
     visit '/static_pages/about'
     page.should have_selector('title',
                               text: "#{base_title}About")
   end
 end

 describe "'contact' page" do

   it "should have the content 'Contact'" do
     visit '/static_pages/contact'
     page.should have_content('Contact')
   end

   it "should have right title" do
     visit '/static_pages/contact'
     page.should have_selector('title',
                               text: "#{base_title}Contact")
   end
 end
end
