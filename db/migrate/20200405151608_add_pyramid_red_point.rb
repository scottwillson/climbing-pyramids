class AddPyramidRedPoint < ActiveRecord::Migration[6.0]
  def change
    change_table :pyramids do |t|
      t.decimal :redpoint_grade_decimal, null: true, default: nil
      t.string :redpoint_grade_letter, null: true, default: nil
    end
  end
end
