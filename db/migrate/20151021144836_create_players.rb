class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :uid, null: false
      t.string :name
      t.string :email
      t.integer :score, null: false, default: 0
      t.string :picture
      t.timestamps
    end
    add_index :players, :uid, unique: true

    create_table :tokens do |t|
      t.string :uid, null: false
      t.string :token, null: false
      t.timestamps
    end
    add_index :tokens, [:uid, :token], unique: true
  end
end
