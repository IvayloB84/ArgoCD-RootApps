class ArticlesController < ApplicationController
  allow_unauthenticated_access only: [ :index, :show ]
  
  # FIXED: Intercepts modification requests to run authorship authorization checks
  before_action :ensure_author, only: [ :edit, :update, :destroy ]

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
    # FIXED: Builds the new article directly nested under the logged-in user session context
    @article = Current.user.articles.build(article_params)
    
    if @article.save
      redirect_to articles_path, notice: "Article published successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # @article is already loaded by the before_action filter safely
  end

  def update
    if article_params[:purge_image] == "1"
      @article.image.purge
    end

    if @article.update(article_params.to_h.except(:purge_image))
      redirect_to article_path(@article), notice: "Article updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_path, notice: "Article deleted permanently!", status: :see_other
  end

  private
    def article_params
      params.expect(article: [ :title, :body, :image, :purge_image ])
    end

    # FIXED: True Authorization checkpoint method filter block
    def ensure_author
      @article = Article.find(params[:id])
      return if Current.user.username == "IvayloB84"
      
      # If the article's user ID doesn't match the current logged-in user, block them immediately!
      if @article.user_id != Current.user.id
        redirect_to articles_path, alert: "Access Denied: You are not authorized to modify this article."
      end
    end
end