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

    [
      "Indoor Top Rope",
      "Indoor Lead",
      "Outdoor Top Rope",
      "Outdoor Lead",
      "Outdoor Trad",
      "Indoor Boulder",
      "Outdoor Boulder"
    ].each do |name|
      Discipline.create! name: name
    end
  end
end
