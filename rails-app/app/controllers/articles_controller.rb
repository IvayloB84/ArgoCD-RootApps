# app/controllers/articles_controller.rb
class ArticlesController < ApplicationController
  # FIXED: Allows anyone to see the feed and read individual articles anonymously!
  allow_unauthenticated_access only: [ :index, :show ]

  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    if @article.save
      redirect_to articles_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])
    if article_params[:purge_image] == "1"
      @article.image.purge
    end

    if @article.update(article_params.to_h.except(:purge_image))
      redirect_to article_path(@article)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # FIXED: Perfectly enclosed and isolated destroy method action
  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    redirect_to articles_path, status: :see_other
  end

  private
    def article_params
      # FIXED: Whitelisted :purge_image token flag into your strong parameters structure
      params.expect(article: [ :title, :body, :image, :purge_image ])
    end
end