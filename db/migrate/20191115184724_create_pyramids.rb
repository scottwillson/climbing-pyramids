# frozen_string_literal: true

class CreatePyramids < ActiveRecord::Migration[6.0]
  def change
    create_table :pyramids, &:timestamps
  end
end
