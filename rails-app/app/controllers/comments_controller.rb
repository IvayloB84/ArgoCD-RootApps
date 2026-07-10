class CommentsController < ApplicationController
  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.build(comment_params)

    if @comment.save
      redirect_to article_path(@article), notice: "Comment posted successfully!"
    else
      redirect_to article_path(@article), alert: "Could not save comment: #{@comment.errors.full_messages.join(', ')}"
    end
  end

  # FIXED: Added the missing destroy action to locate and delete the comment safely
  def destroy
    @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])
    @comment.destroy

    redirect_to article_path(@article), notice: "Comment was deleted successfully!", status: :see_other
  end

  private
    def comment_params
      params.require(:comment).permit(:body, :commenter)
    end
end