class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:update, :edit]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
    @relationship = current_user.relationships.new

    @today_book =  @books.created_today
    @yesterday_book = @books.created_yesterday
    @this_week_book = @books.created_this_week
    @last_week_book = @books.created_last_week

    # グラフ化のための変数
    @book_by_day = @books.group_by_day.(:created_at).size #日毎の投稿データをグルーピング。ハッシュの形式になっている
    @chartlabels = @book_by_day.map(&:first).to_json.html_safe
    @chartdatas = @book_by_day.map(&:second)#日毎の投稿数の値のみ取得

    # DM機能の中間テーブル
    @current_entries = Entry.where(user_id: current_user.id)  #ログイン中のユーザが有する全てのエントリー
    @another_entries = Entry.where(user_id: @user.id)         #詳細ページのユーザが有する全てのエントリー
    unless @user.id == current_user.id
      @current_entries.each do |current|
        @another_entries.each do |another|
          if current.room_id == another.room_id               #上記の２人のユーザのテーブルが既に存在するか確認
            @is_room = true
            @room_id = current.room_id
          end
        end
      end
    end
    unless @is_room
      @room = Room.new
      @entry = Entry.new
    end
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end