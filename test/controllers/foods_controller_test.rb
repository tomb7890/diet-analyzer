require 'test_helper'

class FoodsControllerTest < ActionController::TestCase
  include FactoryBot::Syntax::Methods
  include Devise::Test::ControllerHelpers

  setup do
    @bob = user_with_days
    sign_in @bob
  end

  test "should create a list of matching foods returning from API call" do
    get :new,
        params: {"utf8"=>"✓",
                 "search"=>"clam chowder new england prepared",
                 "commit"=>"Submit",
                 "day_id"=>@bob.days.first.id},
        session: { user_id: @bob }

    assert_response :success
  end
end
