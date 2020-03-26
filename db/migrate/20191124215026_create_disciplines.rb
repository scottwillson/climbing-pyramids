# frozen_string_literal: true

class CreateDisciplines < ActiveRecord::Migration[6.0]
  def change
    Climb.delete_all

    create_table :disciplines do |t|
      t.string :name, default: "Unamed", null: false
      t.timestamps
    end

    change_table :climbs do |t|
      t.belongs_to :discipline
    end

    change_table :pyramids do |t|
      t.belongs_to :discipline
    end
  end
end
