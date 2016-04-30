class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.integer :player_id, null: false
      t.string :state, null: false
      t.decimal :seconds, precision: 12, scale: 2, null: false, default: 0
      t.decimal :start, precision: 12, scale: 2, null: false
      t.integer :score, null: false
      t.timestamps
    end

  end
end