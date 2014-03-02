require 'test_helper'

class FindIntegrationTest < ActionDispatch::IntegrationTest

  setup do
    CompanyCache.delete_all
    CompanyCache.create!(name: "Made up company", identity: "999-999-999")
  end

  test "can be found at root route and requires no parameters" do
    get '/'
    assert_template :find
    assert_response :success
  end

  test "should find item in cache" do
    get '/find', name: "Made up company"
    assert_response :success
    assert_equal "999-999-999", assigns(:company).identity
  end

  test "should find items in backend" do
    get '/find', name: "Redpill Linpro AB"
    assert_response :success
    assert_equal "556641-0576", assigns(:company).identity
  end

end
