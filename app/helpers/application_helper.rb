module ApplicationHelper
  def datetime_encorder(target_datetime)
    if target_datetime.present?
      target_datetime.strftime("%H:%M")
    else
      ""
    end
  end
  def stay_time(enter_at, exit_at)
    if exit_at.present? && enter_at.present?
      sec = (exit_at.to_time - enter_at.to_time).to_i
      hour = sec / 3600
      min = format("%0*d", 2, (sec / 60 - hour * 60))       #TODO: リファクタリングしろ
      staytime = (format("%0*d", 2, hour).to_s + ':' + min)
    else
      staytime = '在室中'
    end
    staytime
  end
end
