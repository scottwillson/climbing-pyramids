class AddPersonMountainProjectUserId < ActiveRecord::Migration[6.0]
  def change
    add_column :people, :mountain_project_user_id, :string, null: true, default: nil
  end
end
