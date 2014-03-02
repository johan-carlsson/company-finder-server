require 'test_helper'

class CompanyCacheTest < ActiveSupport::TestCase

  test "should have a representable to_s" do
    company=CompanyCache.new(name: "A Company", identity: "333-666-999")
    assert_equal company.to_s,"Name: A Company Identity: 333-666-999"
  end

  test "should validate uniqness of name" do 
    assert CompanyCache.create(:name => "A Company").valid?
    assert CompanyCache.create(:name => "A Company").invalid?
  end

  test "should validate presense of name" do
    assert CompanyCache.new(:name => "").invalid? 
  end

  test "should store company" do 
    company=Company.new("A new company","123-456");
    assert_difference('CompanyCache.count', 1) do
      CompanyCache.store_company!(company)
    end
  end

end
