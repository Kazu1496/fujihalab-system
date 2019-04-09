class Api::V1::UsersController < ApplicationController
  skip_before_action :require_sign_in!
  before_action :white_list_ip?

  protect_from_forgery :except => [:get]

  def get
    render json: User.all.as_json(only: [:status, :address])
  end
end
