class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :pan_card_no
      t.bigint :aadhar_card_no

      t.timestamps
    end
  end
end
