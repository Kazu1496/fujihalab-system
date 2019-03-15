namespace :attendance do
  desc "23:59時点で出席状態のユーザーを一度退席状態にし、その後出席状態に戻す"
  task attendance: :environment do
    Attendance.batch
  end
end
