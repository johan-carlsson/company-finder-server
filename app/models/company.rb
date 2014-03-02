class Company
  attr_accessor :name, :identity

  def initialize(name,identity)
    self.name=name
    self.identity=identity
  end

  def to_s
    "Name: #{name} Identity: #{identity}"
  end

  def self.cache
    CompanyCache 
  end

  def self.backend
    CompanyBackend 
  end

  # Raises ActiveRecordErrors and CompanyBackendErrors
  # Returns null if no company is found
  def self.find_by_name(name)
    return if name.blank?
    # Find in cache OR find in backend and store in cache
    cache.find_by_name(name) || ((found=backend.find_company_by_name(name)) && cache.store_company!(found))
  end

end
