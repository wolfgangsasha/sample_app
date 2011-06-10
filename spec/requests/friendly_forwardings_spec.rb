require 'spec_helper'

describe "FriendlyForwardings" do

  it "should forward user ot the requested page after signin" do
    user = Factory(:user)
    visit edit_user_path(user)
    #should automatically send user to the signin  page since they are loggedin
    fill_in :email,	:with => user.email
    fill_in :password,	:with => user.password
    click_button
    # test should redirect user to edit page since that is where they wanted to go
    response.should render_template('users/edit')
  end

end
