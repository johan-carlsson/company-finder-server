require 'company_backend'
class CompaniesController < ApplicationController
  # GET /companies/find
  def find 
    begin
     @company = Company.find_by_name(params[:name])
    rescue BackendError => e
     logger.warn "BackendError: #{e}"
     @error = "Backend error" 
     @status = :internal_server_error
    rescue Exception => e
      logger.error "InternalError: #{e}"
      @error = "Internal error"
      @status = :internal_server_error
    end

    unless @company
      @error||="Not found"
      @status||=:not_found
    end

    respond_to do |format|
      format.html
      if @company
        format.json 
        format.xml
      else
        format.json { render json: { error: @error }, status: @status }
        format.xml { render xml: { error: @error }.to_xml(root: "company"), status: @status }
      end
    end
  end

end
