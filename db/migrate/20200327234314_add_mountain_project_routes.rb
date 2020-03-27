# frozen_string_literal: true

class AddMountainProjectRoutes < ActiveRecord::Migration[6.0]
  def change
    change_table :climbs, bulk: true do |t|
      t.string :mountain_project_route_id, null: true, default: nil
      t.string :name, null: true, default: nil
    end
  end
end
