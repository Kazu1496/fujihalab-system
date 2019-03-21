module ApplicationHelper
  def from_pc?
    not from_sp? && @current_user.present?
  end

  def from_sp?
    browser.device.mobile? && @current_user.present?
  end
end
