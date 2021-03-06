require 'open-uri'
class BackendError < RuntimeError;end

class CompanyBackend
  BASE_URL="http://www.allabolag.se"
  class << self
    def find_company_by_name(name)
      begin
        if(found=scrape_for_identity(name))
          Rails.logger.info("CompanyBackend found: #{found} for: #{name}")
          company=Company.new(name,found) 
        else
          Rails.logger.info("CompanyBackend could not find: #{name}")
        end
      rescue => e
        Rails.logger.error("ERROR: Failed to scrape identity for: #{name} excpetion: #{e}")
        raise BackendError, e
      end

      return company
    end  

    private 

    def scrape_for_identity(name)
      uri_for(name).open do |f|
        parse(f.read)
      end
    end

    def uri_for(name)
      URI.parse(URI.escape("#{BASE_URL}/?what=#{name}"))
    end

    # <td class="text11grey6">
    #  <span class="bold11grey6">Org.nummer:</span> 556641-0576<br>
    #  <span class="bold11grey6">Verksamhet:</span> Utgivning av annan programvara<br>
    # </td>
    def parse(html)
      page=Nokogiri::HTML(html)

      # This ain't pretty
      identity_node=page.xpath("//span[text()='Org.nummer:']/../text()")[1]
      identity_node.text.strip if identity_node
    end

  end
end
