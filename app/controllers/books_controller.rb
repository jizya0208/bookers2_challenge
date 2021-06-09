class BooksController < ApplicationController
  before_action :ensure_correct_user, only: [:edit]

  def show
    @book = Book.find(params[:id])
    @new_book = Book.new
    @book_comment = BookComment.new

    # 作成日時で分類するために自分で作ったコード。15行と長い。
    now = Time.current
    from = now.at_beginning_of_day
    to = from + 1.day
    yesterday = now.yesterday.at_beginning_of_day
    this_week = from - 6.day
    last_week = this_week - 7.day
    @book_today = Book.where("created_at > ?", from ).where("created_at < ?", to ).size
    @book_yesterday = Book.where("created_at > ?", yesterday).where("created_at < ?", from ).size
    unless @book_yesterday == 0
      @previous_day_ratio = @book_today.fdiv(@book_yesterday) * 100
    end
    @book_this_week = Book.where("created_at > ?", this_week ).where("created_at < ?", now).size
    @book_last_week = Book.where("created_at > ?", last_week ).where("created_at < ?", this_week).size
    unless @book_last_week == 0
      @previous_week_ratio = @book_this_week.fdiv(@book_last_week) * 100
    end

  end

  def index
    @book = Book.new
    @books = Book.all
    # 直近のいいね 数の多さで並べ替えるときの記述
    # one_week_ago = Date.today - 7
    # @books = Book.all.sort {|a,b| b.favorites.where("created_at > ?", one_week_ago).size <=> a.favorites.where("created_at > ?", one_week_ago).size}
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :rate)
  end

  def ensure_correct_user
    @book = Book.find(params[:id])
    unless @book.user_id == current_user.id
      redirect_to books_path
    end
  end
end
