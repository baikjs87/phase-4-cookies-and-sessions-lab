class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    count = session[:page_views] ||= 0
    article = Article.find(params[:id])
    count += 1
    if count <= 3
      render json: article
      byebug
    elsif count > 3
      render json: unauthorized
      # count = 0
    end

  end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

  def unauthorized
    render json: { errors: "Maximum pageview limit reached" }, status: :unauthorized
  end

end
