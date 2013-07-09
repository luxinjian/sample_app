require'spec_helper'

describe "StaticPages" do

  shared_examples_for "all static pages" do
    subject { page }

    it { should have_selector('h1', text: heading) }
    it { should have_selector('title', text: full_title(page_title)) }
  end

  describe "'home' page" do
    before { visit root_path }
    let(:heading) { 'Sample App' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_selector('title',
                                  text: full_title('Home')) }
  end

  describe "'help' page" do
    before { visit help_path }
    let(:heading) { 'Help' }
    let(:page_title) { 'Help' }

    it_should_behave_like "all static pages"
  end

  describe "'about' page" do
    before { visit about_path }
    let(:heading) { 'About Us' }
    let(:page_title) { 'About' }

    it_should_behave_like "all static pages"
  end

  describe "'contact' page" do
    before { visit contact_path }
    let(:heading) { 'Contact' }
    let(:page_title) { 'Contact' }

    it_should_behave_like "all static pages"
  end

  it "should have right link with right page" do
    visit root_path

    click_link 'Home'
    page.should have_selector('h1', text: 'Sample App')
    click_link 'Help'
    page.should have_selector('h1', text: 'Help')
    click_link 'About'
    page.should have_selector('h1', text: 'About Us')
    click_link 'Contact'
    page.should have_selector('h1', text: 'Contact')
    click_link 'Home'
    click_link 'Sign up now!'
    page.should have_selector('h1', text: 'Sign up')
    click_link 'Sample app'
    page.should have_selector('h1', text: 'Sample App')
  end
end