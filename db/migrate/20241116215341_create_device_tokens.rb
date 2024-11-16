class CreateDeviceTokens < ActiveRecord::Migration[7.2]
  def change
    create_table :device_tokens, id: :uuid do |t|
      t.string :token
      t.references :device, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
