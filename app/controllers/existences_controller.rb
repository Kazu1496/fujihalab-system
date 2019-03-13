require 'net/https'
require 'open-uri'

class ExistencesController < ApplicationController
  before_action :set_access, only: [:edit, :update]

  def edit; end

  def update
    user = User.find_by(id: @existence.user_id)
    existences = Existence.where(
      user_id: user.id,
      enter_time: @existence.enter_time.in_time_zone.all_day
    )
    enter_time = update_time(@existence.enter_time, params[:existence][:enter_time].to_time)
    exit_time = update_time(@existence.exit_time, params[:existence][:exit_time].to_time)

    @existence.update(
      enter_time: enter_time,
      exit_time: exit_time
    )

    if @existence.saved_change_to_exit_time?
      user.update(status: false)
    end

    #delete_pixel
    delete_pixel(user, @existence.enter_time.strftime("%Y%m%d"))

    respond_to do |format|
      if create_pixel(user, @existence.enter_time, existences) #Create Pixel
        format.html { redirect_to user_path(@existence.user_id), notice: '更新しました。' }
      else
        flash[:alert] = pixel_result
        format.html { render :edit }
      end
    end
  end

  private
    def set_access
      @existence = Existence.find_by(id: params[:id])
    end
end
