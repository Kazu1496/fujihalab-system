class Api::V1::UsersController < ApplicationController
  skip_before_action :require_sign_in!
  before_action :white_list_ip?

  def get
    render json: User.all.as_json(only: [:address, :status])
  end
end
