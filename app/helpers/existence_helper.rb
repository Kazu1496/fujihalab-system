module ExistenceHelper
  def datetime_encorder(datetime)
    if datetime.present?
      datetime.strftime("%H:%M")
    else
      ""
    end
  end

  def stay_time(existence)
    if existence.enter_time.present? && existence.exit_time.present?
      sec = (existence.exit_time.to_time - existence.enter_time.to_time).to_i
      hour = sec / 3600
      min = format("%0*d", 2, (sec / 60 - hour * 60))       #TODO: リファクタリングしろ
      staytime = (format("%0*d", 2, hour).to_s + ':' + min)
    else
      staytime = '出席中'
    end
    staytime
  end
end
