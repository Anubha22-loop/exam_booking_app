class AddUniqueIndexToExamBookings < ActiveRecord::Migration[7.0]
  def change
    add_index :exam_bookings, [:user_id, :exam_id], unique: true
  end
end
