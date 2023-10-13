class TweetsController < ApplicationController
  before_action :set_tweet,only: [:edit, :show]
  before_action :move_to_index, except: [:index, :show, :search]

  def index
    # @tweets = Tweet.includes(:user).order("created_at DESC")
    query = "SELECT * FROM tweets"
    @tweets = Tweet.find_by_sql(query)
  end

  def new
    @tweet = Tweet.new
  end

  def create
    @tweet = Tweet.new(tweet_params)
    #バリデーションに引っ掛からず保存されれば、トップページにリダイレクトする
    if @tweet.save
      redirect_to '/'
    else
      # バリデーションに引っ掛からなければ、「新規投稿」の画面を呼び出す
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    tweet = Tweet.find(params[:id])
    tweet.destroy
    redirect_to root_path
  end

  def edit
  end

  def update
    @tweet = Tweet.find(params[:id])
    if @tweet.update(tweet_params)
      redirect_to root_path
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def show
    @comment = Comment.new
    @comments = @tweet.comments.includes(:user)
  end

  def search
    @tweets = Tweet.search(params[:keyword])
  end

  private
  def tweet_params
    params.require(:tweet).permit(:image, :text).merge(user_id: current_user.id)
  end

  def set_tweet
    @tweet = Tweet.find(params[:id])
  end

  def move_to_index
    unless user_signed_in?
      redirect_to action: :index
    end
  end

end
