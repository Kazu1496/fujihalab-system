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
      flash[:alert] = "無効な値のため、在籍情報の更新ができませんでした。再度やり直してください"
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
      if existence.next.present? && existence.previous.present? && enter_time <= exit_time
        if exit_time <= existence.next.enter_time && existence.previous.exit_time <= enter_time
          true
        end
      elsif existence.next.present?
        if exit_time <= existence.next.enter_time && enter_time <= exit_time
          true
        end
      elsif existence.previous.present?
        if existence.previous.exit_time <= enter_time && enter_time <= exit_time
          true
        end
      elsif enter_time <= exit_time
        true
      else
        false
      end
    end
end
