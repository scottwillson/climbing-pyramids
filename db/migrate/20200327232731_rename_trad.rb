# frozen_string_literal: true

class RenameTrad < ActiveRecord::Migration[6.0]
  def change
    Discipline.where(name: "Outdoor Trad").update_all(name: "Trad")
  end
end
