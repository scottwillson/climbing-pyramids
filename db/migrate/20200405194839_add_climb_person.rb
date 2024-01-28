# frozen_string_literal: true

class AddClimbPerson < ActiveRecord::Migration[6.0]
  def change
    change_table :climbs do |t|
      t.references :person
    end

    change_table :pyramids do |t|
      t.references :person
    end
  end
end
