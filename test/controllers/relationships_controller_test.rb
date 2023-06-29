require "test_helper"

class RelationshipsControllerTest < ActionDispatch::IntegrationTest
  test "should get follower" do
    get relationships_follower_url
    assert_response :success
  end

  test "should get followed" do
    get relationships_followed_url
    assert_response :success
  end
end
