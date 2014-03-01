require 'test_helper'
require 'minitest/mock'

class CompaniesControllerTest < ActionController::TestCase
  setup do
    @company=Company.new("A company","123-456")
    CompanyCache.store_company!(@company)
  end

  test "should find company" do
    get :find, name: "A company"
    assert_equal "A company", assigns(:company).name
    assert_response :success
  end

  test "should find in json format" do
    get :find, format: :json, name: "A company"
    assert_equal %Q({"name":"A company","identity":"123-456"}),@response.body
  end

  test "should find in xml format" do
    get :find, format: :xml, name: "A company"
    xml=<<-XML
<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<company>
  <name>A company</name>
  <identity>123-456</identity>
</company>
    XML
    assert_equal xml,@response.body
  end

  test "should not assign company if name param is missing" do
    get :find
    assert_not assigns(:company)
    assert_response :success
  end  

  test "should not assign company if company not found" do
    Company.stub :find_by_name, nil do
      get :find, name: "Not a valid company"
      assert_not assigns(:company)
      assert_response :success
    end
  end  

  test "should assign errors if company not found" do
    Company.stub :find_by_name, nil do
      get :find, name: "Not a valid company"
      assert assigns(:error)
      assert_response :success
    end
  end  
  
  test "should responde with json error structure and :not_found if company not found using json" do
    Company.stub :find_by_name, nil do
      get :find, format: :json,  name: "Not a valid company"
      assert_response :not_found
      assert_equal %Q({"error":"Not Found"}),@response.body
    end
  end  

  test "should responde with xml error structure and :not_found if company not found using xml" do
    Company.stub :find_by_name, nil do
      get :find, format: :xml,  name: "Not a valid company"
      assert_response :not_found
      xml=<<-XML
<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<company>
  <error>Not Found</error>
</company>
      XML
      assert_equal xml,@response.body
    end
  end  

  # TODO Should handle ActiveRecordErrors
  # TODO Should handle CompanyBackendErrors

end
