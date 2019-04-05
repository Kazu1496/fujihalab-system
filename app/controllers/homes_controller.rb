class HomesController < ApplicationController
  skip_before_action :require_sign_in!, only: [:privacy_policy]

  def privacy_policy; end
end
