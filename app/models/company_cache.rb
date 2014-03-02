class CompanyCache < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  def to_s
    "Name: #{name} Identity: #{identity}"
  end

  def self.store_company!(company)
    CompanyCache.create!(name: company.name,identity: company.identity)
  end

end
