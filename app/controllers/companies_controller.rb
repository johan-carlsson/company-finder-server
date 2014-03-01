class CompaniesController < ApplicationController
  # GET /companies/find
  def find 
    #TODO Handle errors
    @company = Company.find_by_name(params[:name])

    @error="Not Found" unless @company

    respond_to do |format|
      format.html
      if @company
        format.json 
        format.xml
      else
        format.json {render json: {error: @error}, status: :not_found}
        format.xml {render xml: {error: @error}.to_xml(root: "company"), status: :not_found}
      end
     end
  end
end
