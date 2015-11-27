class SearchesController < ApplicationController
  def create
    @search = Search.new(search_params)
    if @search.save
      # Trigger background job
      EbayCrawlerWorker.perform_async(@search.id)
    end
  end

  def show
    @search = Search.find(params[:id])
    if @search.done?
      @search_results = @search.search_results.collect do |item|
        "<li>#{ActionController::Base.helpers.number_to_currency(item.price, unit: '€')} <a href=\"#{item.link}\">#{item.name}</a></li>"
      end.join("")
    end
  end

  private
  def search_params
    params.require(:search).permit(:keyword)
  end
end
