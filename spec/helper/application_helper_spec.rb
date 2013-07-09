require 'spec_helper'

describe ApplicationHelper do

  describe "full_title" do

    it "should include page title" do
      full_title('foo').should =~ /foo/
    end

    it "should include base title" do
      full_title('foo').should =~ /^Ruby on Rails/
    end

    it "should not include a bar for the absence of page title" do
      full_title('').should_not =~ /\|/
    end
  end
end
