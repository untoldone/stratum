class CreateCorrespondences < ActiveRecord::Migration[7.2]
  def change
    create_table :correspondences, id: :uuid do |t|
      t.string :subject
      t.string :sender
      t.string :recipient
      t.datetime :sent_at
      t.references :document, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
