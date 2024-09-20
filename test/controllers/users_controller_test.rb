require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  
  test "get new" do
    get :new
    assert_response :success
  end

  test "root path is routed" do
    assert_recognizes({controller: 'days',
                       action: 'index'},
                      {path: '/'})
  end

  test "route of ajax handler #2" do
    assert_recognizes(
      {controller: 'foods',
       action: 'update_measures'},
      {path: '/update_measures'})
                     
  end
end
