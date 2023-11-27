class DiscoverController < ApplicationController
  before_action :authenticate_user!

  def index
    unless APP_CONFIG.dig(:features, :discover, :enabled) || current_user.mod?
      return redirect_to root_path
    end

    top_x = 10  # only display the top X items

    @popular_answers = Answer.for_user(current_user).where("created_at > ?", Time.now.utc.ago(1.week)).order(:smile_count).reverse_order.limit(top_x).includes(:question, :user, :comments)
    @most_discussed = Answer.for_user(current_user).where("created_at > ?", Time.now.utc.ago(1.week)).order(:comment_count).reverse_order.limit(top_x).includes(:question, :user, :comments)
    @popular_questions = Question.where("created_at > ?", Time.now.ago(1.week)).order(:answer_count).reverse_order.limit(top_x).includes(:user)
    @new_users = User.where("asked_count > 0").order(:id).reverse_order.limit(top_x).includes(:profile)

    # .user = the user
    # .question_count = how many questions did the user ask
    @users_with_most_questions = Question.select('user_id, COUNT(*) AS question_count').
        where("created_at > ?", Time.now.ago(1.week)).
        where(author_is_anonymous: false).
        group(:user_id).
        order('question_count').
        reverse_order.limit(top_x)

    # .user = the user
    # .answer_count = how many questions did the user answer
    @users_with_most_answers = Answer.select('user_id, COUNT(*) AS answer_count').
        where("created_at > ?", week_ago).
        group(:user_id).
        order('answer_count').
        reverse_order.limit(top_x)
  end
end
