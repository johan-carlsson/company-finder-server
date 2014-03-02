require 'test_helper'
require 'minitest/mock'

class CompanyBackendTest < ActiveSupport::TestCase
  HTML=File.open("#{Rails.root}/test/fixtures/Redpill.html").read 

  test "parse should find first occurrence of identity from response" do
    assert_equal "556641-0576",CompanyBackend.parse(HTML)
  end

  test "parse should return nil if no occurrence of identity is found" do
    assert_nil CompanyBackend.parse("Nothing to be found here") 
  end

  test "uri_for should escape uri" do
    assert_equal "http://www.allabolag.se/?what=R%20R",CompanyBackend.uri_for("R R").to_s
  end

  test "should find company by name" do
    company=Company.new("A company","123-456")
    CompanyBackend.stub :scrape_for_identity, "123-456" do
      result=CompanyBackend.find_company_by_name("A company")
      assert_equal company.to_s, result.to_s
    end
  end

end
