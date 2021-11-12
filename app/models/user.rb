class User < ApplicationRecord
  has_one :user_acc_detail, inverse_of: :user, :dependent => :destroy
  has_one :credibility_detail, inverse_of: :user, :dependent => :destroy
  accepts_nested_attributes_for :user_acc_detail, allow_destroy: true
  
  validates :name, :email, presence: true 
  after_save :set_credit_limit_and_term_in_months

  def set_credit_limit_and_term_in_months
    max_possible_emi = maximum_possible_emi(self.user_acc_detail.inflow, self.user_acc_detail.outflow)
    term_in_months = get_term_in_month(max_possible_emi)
    create_credibility_details(self, max_possible_emi, term_in_months)
  end

  def create_credibility_details(user, max_possible_emi, term_in_months)
    return if user.blank? || max_possible_emi.blank? || term_in_months.blank?

    credibility_detail = CredibilityDetail.find_or_create_by({ user_id: user })
    credibility_detail.update({
      credit_limit: (max_possible_emi * term_in_months),
      max_possible_emi: max_possible_emi.negative? ? 0 : max_possible_emi,
      term_in_months: term_in_months,
      eligibility_status: (term_in_months > 0 && max_possible_emi > 0) ? "Eligible" : "Reject",
      user: user
    })
  end

  def maximum_possible_emi(cash_inflow, cash_outflow)
    return if cash_inflow.blank? || cash_outflow.blank?

    (cash_inflow / 2) - cash_outflow
  end
  
  def get_term_in_month(max_possible_emi)
    return 0 if(max_possible_emi < 0)

    term_in_month = case max_possible_emi
      when 0..5000
        return 6
      when 5001..10000
        return 12
      when 10001..20000
        return 18
      else
        24
      end
  end
end
