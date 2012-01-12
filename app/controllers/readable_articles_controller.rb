class ReadableArticlesController < ApplicationController

  def create
    url = params[:url]
    @r = ReadableArticle.find_by_url(url) || ReadableArticle.create(:url=>url)
    @r.fetch_content!
  end

  def show
    @r = ReadableArticle.find(params[:id])
  end

end
