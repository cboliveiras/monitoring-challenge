class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.string :time
      t.string :status
      t.integer :count

      t.timestamps
    end
  end
end
