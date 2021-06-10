class SearchController < ApplicationController
  def search
    @model = params["model"]
    @content = params["content"]
    @method = params["method"]
    @records = search_for(@model,@content,@method)
  end

  def category_search
    @user = 
    @book = Book.new
    @category = category(params[:category])
  end

  private
  def search_for(model,content,method)
    if model == 'User'
      case method
      when "perfect"
        User.where(name: content)
      when "forward"
        User.where('name LIKE ?', content + '%')
      when "backward"
        User.where('name LIKE ?', '%' + content)
      when "partial"
        User.where('name LIKE ?', '%'+content+'%')
      end
    else
      case method
      when "perfect"
        Book.where(title: content)
      when "forward"
        Book.where('title LIKE ?', content + '%')
      when "backward"
        Book.where('title LIKE ?', '%' + content)
      when "partial"
        Book.where('title LIKE ?', '%'+content+'%')
      end
    end
  end

  def category(category_name)
    Book.where(category: category_name)
  end
end
