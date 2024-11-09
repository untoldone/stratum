class AddDocumentOpenAiResponse < ActiveRecord::Migration[7.2]
  def change
    add_column :documents, :interpretation, :jsonb
  end
end
