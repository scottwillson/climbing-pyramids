# frozen_string_literal: true

class CreatePeople < ActiveRecord::Migration[6.0]
  def change
    create_table :people, &:timestamps
  end
end
