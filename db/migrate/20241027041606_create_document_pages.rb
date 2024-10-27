class CreateDocumentPages < ActiveRecord::Migration[7.2]
  def change
    create_table :document_pages, id: :uuid do |t|
      t.integer :index
      t.references :document, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
