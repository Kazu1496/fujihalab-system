module ApplicationHelper
  def datetime_encorder(target_datetime)
    if (target_datetime = 0)
      ""
    else
      target_datetime.strftime("%H時M分")
    end
  end
end
