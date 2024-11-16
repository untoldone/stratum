class CreateAccounts < ActiveRecord::Migration[7.2]
  def change
    create_table :accounts, id: :uuid do |t|
      t.timestamps
    end

    create_table :accounts_users, id: :uuid do |t|
      t.references :user, type: :uuid
      t.references :account, type: :uuid

      t.timestamps
    end

    add_reference :documents, :account, type: :uuid
    add_reference :correspondences, :account, type: :uuid
  end
end
