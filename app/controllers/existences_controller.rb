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

    if update_condition(@existence, params[:existence][:enter_time].to_time, params[:existence][:exit_time].to_time)
      @existence.update(
        enter_time: enter_time,
        exit_time: exit_time
      )
    else
      flash[:alert] = "無効な値が入力されたため、在籍情報の更新ができませんでした。再度やり直してください"
      redirect_to edit_user_existence_path(user.id, @existence.id) and return
    end

    total_time = total_time(Existence.where(user_id: user.id))
    user.update!(total_time: total_time)

    #delete_pixel
    delete_pixel(user, @existence.enter_time.strftime("%Y%m%d"))

    respond_to do |format|
      if create_pixel(user, @existence.enter_time, total_time) #Create Pixel
        format.html { redirect_to user_path(@existence.user_id), notice: '在籍情報を更新しました。' }
      else
        flash[:alert] = "在籍情報の更新ができませんでした。再度やり直してください"
        format.html { render :edit }
      end
    end
  end

  private
    def set_access
      @existence = Existence.find_by(id: params[:id])
    end

    # TODO さすがにどうにかしたい
    def update_condition(existence, enter_time, exit_time)
      if enter_time <= exit_time && exit_time < Time.now
        if existence.next.present? && existence.previous.present?
          result = (exit_time <= existence.next.enter_time && existence.previous.exit_time <= enter_time) ? true : false
        elsif existence.next.present? && enter_time
          result = (exit_time <= existence.next.enter_time) ? true : false
        elsif existence.previous.present?
          result = (existence.previous.exit_time <= enter_time) ? true : false
        else
          result = (enter_time <= exit_time && exit_time < Time.now) ? true : false
        end
      else
        result = false
      end
    end
end
