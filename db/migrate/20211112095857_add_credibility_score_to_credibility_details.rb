class AddCredibilityScoreToCredibilityDetails < ActiveRecord::Migration[6.1]
  def change
    add_column :credibility_details, :credibility_score, :bigint, :default => 0
    add_column :credibility_details, :eligibility_status, :string
    add_column :credibility_details, :approved_user, :boolean, :default => nil
  end
end
