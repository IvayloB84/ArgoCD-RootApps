class RatingsController < ApplicationController
  rescue_from ActionController::ParameterMissing, with: :handle_missing_rating

  def create
    @article = Article.find(params[:article_id])
    
    # Fail-safe check if a user tries to force a duplicate record via API/curl
    if @article.ratings.exists?(user_id: Current.user.id)
      redirect_to article_path(@article), alert: " You have already rated this article."
      return
    end

    @rating = @article.ratings.build(rating_params)
    @rating.user = Current.user

    if @rating.save
      redirect_to article_path(@article), notice: " Thank you for rating this article!"
    else
      redirect_to article_path(@article), alert: " Invalid rating score."
    end
  end

  # 🗑️ REMOVE VOTE: Allows users to retract their rating at any time
  def destroy
    @article = Article.find(params[:article_id])
    @rating = @article.ratings.find_by!(user_id: Current.user.id)
    @rating.destroy

    redirect_to article_path(@article), notice: "🗑️ Your rating was successfully removed."
  end

  private
    def rating_params
      params.require(:rating).permit(:score)
    end
end