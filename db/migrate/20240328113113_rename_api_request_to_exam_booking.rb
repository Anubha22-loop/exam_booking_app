class RenameApiRequestToExamBooking < ActiveRecord::Migration[7.0]
  def change
    rename_table :api_requests, :exam_bookings
  end
end
