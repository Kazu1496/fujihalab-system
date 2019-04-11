class HomesController < ApplicationController
  skip_before_action :require_sign_in!, only: [:privacy_policy]

  def index
    @users = User.where(status: true)
  end

  def ranking
    @users = User.all.order(total_time: :desc)
  end

  def member
    @users = User.all
  end

  def privacy_policy; end
end
