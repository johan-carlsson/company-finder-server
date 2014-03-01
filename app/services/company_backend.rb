class BackendError < RuntimeError;end

class CompanyBackend
  def self.find_company_by_name(name)
    #Dummy
    Company.new(name,"1") 
  end  
end
