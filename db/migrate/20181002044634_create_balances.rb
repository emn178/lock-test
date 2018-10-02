class CreateBalances < ActiveRecord::Migration[5.1]
  def change
    create_table :balances do |t|
      t.integer :value

      t.timestamps
    end
  end
end
