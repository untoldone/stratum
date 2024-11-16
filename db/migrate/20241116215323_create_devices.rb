class CreateDevices < ActiveRecord::Migration[7.2]
  def change
    create_table :devices, id: :uuid do |t|
      t.string :name
      t.references :account, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
