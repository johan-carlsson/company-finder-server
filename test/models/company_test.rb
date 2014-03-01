require 'test_helper'
require 'minitest/mock'

class CompanyTest < ActiveSupport::TestCase
  setup do
    @cache = Minitest::Mock.new
    @backend = Minitest::Mock.new
  end


  test "should be initialized by name and identity" do 
    company=Company.new("A Company","123-456") 
    assert_equal company.name,"A Company"
    assert_equal company.identity,"123-456"
  end

  test "should have a representable to_s" do
    c=Company.new("Name","0")
    assert_equal c.to_s, "Name: Name Identity: 0"
  end

  test "should have a cache" do
    assert_equal Company.cache,CompanyCache
  end

  test "should have a backend service" do 
    assert_equal Company.backend,CompanyBackend
  end


  test "find_by_name should find in cache" do 
    Company.stub :cache, @cache do
      @cache.expect(:find_by_name, :null, ["A company"])
      Company.find_by_name("A company")
      @cache.verify
    end
  end

  test "find_by_name should find in backend service" do
    company = Company.new("A new company","123-456")

    Company.stub :backend, @backend do
      @backend.expect(:find_company_by_name, company, ["A new company"])
      Company.find_by_name("A new company")
      @backend.verify
    end
  end

  test "find_by_name should cache if found in backend" do 
    company = Company.new("A new company","123-456")

    Company.stub :backend, @backend do
      Company.stub :cache, @cache do
        @cache.expect(:find_by_name, nil, ["A new company"])
        @backend.expect(:find_company_by_name, company, ["A new company"])
        @cache.expect(:store_company!, true, [company])

        Company.find_by_name("A new company")

        @cache.verify
        @backend.verify
      end
    end
  end

  test "find_by_name should not store in cache if not found in backend" do 
    Company.stub :backend, @backend do
      Company.stub :cache, @cache do
        @cache.expect(:find_by_name, nil, ["A none existing company"])
        @backend.expect(:find_company_by_name, false, ["A none existing company"])

        Company.find_by_name("A none existing company")

        # No call to store_company should be made
        @cache.verify
        @backend.verify
      end
    end
  end

  # Can raise ActiveRecordErrors
  # Can raise BackendErrors
end
