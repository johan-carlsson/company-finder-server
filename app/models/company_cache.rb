class CompanyCache < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  def to_s
    "Name: #{name} Identity: #{identity}"
  end

  # def self.find_company_by_name(name)
  #   if (cached=self.find_by_name(name))
  #     company=Company.new(cached.name,cached.identity)
  #   end
  #   return company
  # end

  def self.store_company!(company)
    CompanyCache.create!(name: company.name,identity: company.identity)
  end

end
