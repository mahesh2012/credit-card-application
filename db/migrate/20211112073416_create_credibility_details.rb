class CreateCredibilityDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :credibility_details do |t|
      t.bigint :credit_limit
      t.bigint :max_possible_emi
      t.bigint :term_in_months
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
