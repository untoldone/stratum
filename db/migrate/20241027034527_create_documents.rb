class CreateDocuments < ActiveRecord::Migration[7.2]
  def change
    create_table :documents, id: :uuid do |t|
      t.timestamps
    end
  end
end
