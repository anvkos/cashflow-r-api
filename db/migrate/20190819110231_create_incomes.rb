class CreateIncomes < ActiveRecord::Migration[5.2]
  def change
    create_table :incomes do |t|
      t.references :user, foreign_key: true
      t.references :category, foreign_key: true
      t.references :account, foreign_key: true
      t.integer :amount, null: false
      t.string :description
      t.timestamp :payment_at, null: false

      t.timestamps
    end

    add_index :incomes, [:user_id, :payment_at]
  end
end
