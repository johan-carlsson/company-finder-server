require 'open-uri'
class BackendError < RuntimeError;end

class CompanyBackend
  BASE_URL="http://www.allabolag.se"

  def self.find_company_by_name(name)
    begin
      identity=self.scrape_identity(name)
    rescue => e
      Rails.logger.error("ERROR: Failed to scrape identity for: #{name} excpetion: #{e}")
      raise BackendError, e
    end

    if identity
      Rails.logger.info("CompanyBackend found: #{identity} for: #{name}")
      company=Company.new(name,identity) 
    else
      Rails.logger.info("CompanyBackend could not find: #{name}")
    end

    return company
  end  

  def self.scrape_identity(name)
    uri_for(name).open {|f|
      parse(f.read)
    }
  end

  def self.uri_for(name)
    URI.parse(URI.escape("#{BASE_URL}/?what=#{name}"))
  end

  # <td class="text11grey6">
  #  <span class="bold11grey6">Org.nummer:</span> 556641-0576<br>
  #  <span class="bold11grey6">Verksamhet:</span> Utgivning av annan programvara<br>
  # </td>
  def self.parse(html)
    page=Nokogiri::HTML(html)

    #This ain't pretty
    identity_node=page.xpath("//span[text()='Org.nummer:']/../text()")[1]
    identity_node.text.strip if identity_node
  end

end
