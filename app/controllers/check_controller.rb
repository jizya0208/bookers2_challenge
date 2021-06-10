class CheckController < ApplicationController
  def check
    @record = check_for(params[:date].to_time).where(user_id: params[:user_id])
  end

  private
  def check_for(date)
    Book.where(created_at: date.all_day)
  end
end
