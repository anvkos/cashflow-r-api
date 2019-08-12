class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.references :user, foreign_key: true
      t.references :currency, foreign_key: true
      t.string :name
      t.integer :amount

      t.timestamps
    end
  end
end
