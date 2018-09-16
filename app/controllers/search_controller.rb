class SearchController < ApplicationController
  def search
    @search_query = params[:query] || params[:term]

    @search_results = SearchServices.search(@search_query)

    respond_to do |format|
      format.html
      format.json do
        results = []
        @search_results.each do |(cls, records)|
          records = records.select do |record|
            current_user.can_read?(record)
          end
          next if records.empty?
          results << SearchClassJsonPresenter.new(cls, @search_query)
          records.each do |record|
            results << SearchJsonPresenter.new(record)
          end
        end
        render json: results
      end
    end
  end

  def search_companies
    render json: SearchServices.search_companies(params[:query] || params[:term])
  end
end
