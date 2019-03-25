module ApplicationHelper
  def from_pc?
    not from_sp?
  end

  def from_sp?
    browser.device.mobile?
  end
end
