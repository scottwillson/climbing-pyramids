# frozen_string_literal: true

class AddClimbsMountainMountainProjectId < ActiveRecord::Migration[6.0]
  def change
    Climb.delete_all

    change_table :climbs, bulk: true do |t|
      t.string :mountain_project_tick_id, null: true, default: nil
      t.date :climbed_on, null: false
    end
  end
end
