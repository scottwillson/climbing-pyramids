class AddMoreMpData < ActiveRecord::Migration[6.0]
  def change
    change_table :climbs do |t|
      t.integer :mountain_project_pitches
      t.integer :mountain_project_user_stars
      t.string :mountain_project_lead_style
      t.string :mountain_project_notes
      t.string :mountain_project_style
      t.string :mountain_project_type
      t.string :mountain_project_user_rating
    end
  end
end
