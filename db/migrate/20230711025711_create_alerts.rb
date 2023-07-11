class CreateAlerts < ActiveRecord::Migration[7.0]
  def change
    create_table :alerts do |t|
      t.string :time
      t.string :status
      t.text :message

      t.timestamps
    end
  end
end
