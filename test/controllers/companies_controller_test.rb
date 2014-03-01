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
    expected=<<-XML
<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<company>
  <name>A company</name>
  <identity>123-456</identity>
</company>
    XML
    assert_equal expected,@response.body
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
      assert_equal %Q({"error":"Not found"}),@response.body
    end
  end  

  test "should responde with xml error structure and :not_found if company not found using xml" do
    Company.stub :find_by_name, nil do
      get :find, format: :xml,  name: "Not a valid company"
      assert_response :not_found
      expected=<<-XML
<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<company>
  <error>Not found</error>
</company>
      XML
      assert_equal expected,@response.body
    end
  end  

  test "should handle BackendErrors" do
    Company.stubs(:find_by_name).raises(BackendError) do 
      assert_raises(BackendError) { 
        get :find, name: "Not cached"
      }
    assert_equal "Backend error", assigns(:error)
    end
  end

  test "should handle BackendErrors using json" do
    Company.stubs(:find_by_name).raises(BackendError) do 
      get :find, name: "Not cached", format: :json
      assert_response :internal_server_error 
      assert_equal %Q({"error":"Backend error"}), @response.body
    end
  end

  test "should handle BackendErrors using xml" do
    Company.stubs(:find_by_name).raises(BackendError) do 
      get :find, name: "Not cached", format: :xml

      expected=<<-XML
<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<company>
  <error>Backend error</error>
</company>
      XML

      assert_response :internal_server_error 
      assert_equal expected, @response.body
    end
  end

  test "should handle internal errors" do
    Company.stubs(:find_by_name).raises(Exception) do 
      assert_raises(Exception) { 
        get :find, name: "Not cached"
      }
      assert_equal "Internal error", assigns(:error)
    end
  end

  test "should handle internal errors using json" do
    Company.stubs(:find_by_name).raises(Exception) do 
      get :find, name: "Not cached", format: :json
      assert_response :internal_server_error 
      assert_equal %Q({"error":"Internal error"}), @response.body
    end
  end


  test "should handle InternalErrors using xml" do
    Company.stubs(:find_by_name).raises(Exception) do 
      get :find, name: "Not cached", format: :xml

      expected=<<-XML
<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<company>
  <error>Internal error</error>
</company>
      XML

      assert_response :internal_server_error 
      assert_equal expected, @response.body
    end
  end

end
