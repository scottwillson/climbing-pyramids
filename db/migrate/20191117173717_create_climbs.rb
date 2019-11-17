class CreateClimbs < ActiveRecord::Migration[6.0]
  def change
    create_table :climbs do |t|
      t.decimal :grade_decimal, null: false, default: nil
      t.string :grade_letter, null: false, default: ""
      t.timestamps
    end
  end
end
