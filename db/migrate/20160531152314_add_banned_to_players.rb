class AddBannedToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :banned, :boolean, null: false, default: false
  end
end
