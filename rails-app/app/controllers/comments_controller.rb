# app/controllers/comments_controller.rb
class CommentsController < ApplicationController
  # Captures a comment and binds it directly to the parent article record ID
  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.create(comment_params)
    
    # Redirects the browser straight back to the article page to show the comment
    redirect_to article_path(@article)
  end

  def destroy
    @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])
    @comment.destroy

    redirect_to article_path(@article), status: :see_other
  end
    
  private

  # Strong parameters security block protecting comment data entries
  def comment_params
    params.expect(comment: [ :commenter, :body ])
  end
end