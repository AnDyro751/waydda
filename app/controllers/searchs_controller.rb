class SearchsController < ApplicationController
  layout "search"
  def show
    @custom_js = true
    @current_param = params["query"]
  end
end
