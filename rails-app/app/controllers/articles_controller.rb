# app/controllers/articles_controller.rb
class ArticlesController < ApplicationController
  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
  end

  # FIXED: Initializes a blank article instance object for your HTML form layout
  def new
    @article = Article.new
  end

  # ADDED: Captures the submitted form fields and saves them to your local database file
  def create
    @article = Article.new(article_params)

    if @article.save
      redirect_to articles_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  private

  # ADDED: Strong parameters security barrier protecting your article columns
  def article_params
    params.expect(article: [ :title, :body ])
  end
end