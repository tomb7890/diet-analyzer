require 'test_helper'

class UsersControllerTest < ActionController::TestCase
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
    food_id = '1234'
    day_id = '5678'
    assert_recognizes({controller: 'foods', action: 'update_measures',
                       id: food_id, day_id: day_id},
                      "/days/#{day_id}/foods/#{food_id}/callback_handler_2"
                     )
  end
end
