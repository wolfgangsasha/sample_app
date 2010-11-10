require 'spec_helper'

describe PagesController do
  render_views

  before(:each) do
    @page_succ_msg = "should be successful"
    @title_succ_msg = "should have right title"
    @base_title = "Ruby on Rails Tutorial Sample App | "
  end

  describe "GET 'home'" do
    it @page_succ_msg do
      get 'home'
      response.should be_success
    end
    it @title_succ_msg do
      get 'home'
      response.should have_selector("title", :content => @base_title + "Home")
    end
  end

  describe "GET 'contact'" do
    it @page_succ_msg do
      get 'contact'
      response.should be_success
    end
    it @title_succ_msg do
      get 'contact'
      response.should have_selector("title", :content => @base_title + "Contact")
    end
  end

  describe "GET 'about'" do
    it @page_succ_msg do
      get 'about'
      response.should be_success
    end
    it @title_succ_msg do
      get 'about'
      response.should have_selector("title", :content => @base_title + "About")
    end
  end

  describe "GET 'help'" do
    it @page_succ_msg do
      get 'help'
      response.should be_success
    end
    it @title_succ_msg do
      get 'help'
      response.should have_selector("title", :content => @base_title + "Help")
    end
  end

end
