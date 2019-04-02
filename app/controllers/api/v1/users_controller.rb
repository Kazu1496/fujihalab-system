class Api::V1::UsersController < ApplicationController
  skip_before_action :require_sign_in!
  before_action :white_list_ip?

  def get
    render json: User.where(status: true).as_json(only: [:address])
  end
end
