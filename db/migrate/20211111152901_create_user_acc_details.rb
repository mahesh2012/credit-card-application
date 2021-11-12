class CreateUserAccDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :user_acc_details do |t|
      t.bigint :account_number
      t.string :ifsc
      t.bigint :inflow
      t.bigint :outflow
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
