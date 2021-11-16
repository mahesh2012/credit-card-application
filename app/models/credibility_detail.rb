require 'httparty'
class CredibilityDetail < ApplicationRecord
  belongs_to :user, class_name: "User"
  before_save :set_credibility_score, if: Proc.new { |record| record.is_initial_level? }

  def set_credibility_score
  	return unless self.approved_user

  	set_credibility_by_previous_history
  	set_credibility_by_social_profile
  end

  def is_initial_level?
  	self.credibility_score == 0
  end

  def set_credibility_by_previous_history
  	current_record = CredibilityDetail.find(self.id)
  	if CredibilityDetail.where(user_id: self.user_id, approved_user: true).blank?
  		current_record.update(credibility_score: self.credibility_score.next)
  	end
  end

  def set_credibility_by_social_profile
  	url = "https://api.fullcontact.com/v2/person.json"
  	query = {
  		email: self.user.email
  	}
  	result = HTTParty.get(url, :headers => {
		  "X-FullContact-APIKey" => "#{ENV['FULL_CONTACT_API_KEY']}",
		  "Content-Type" => "application/json"
		});
		raise Exception if result[:status] != 200
		set_credibility(result[:socialProfiles])
  rescue Exception => e
  	puts"Exception======> #{e}"
  	set_credibility(stubed_data[:socialProfiles])
  end

  def set_credibility(socialProfiles)
  	current_record = CredibilityDetail.find(self.id)
  	credibility_score = current_record.credibility_score
  	socialProfiles.each do|profile|
  		credibility_score += 1 if(profile[:type] == 'linkedin')
  		credibility_score += 1 if(profile[:type] == 'twitter')
  		credibility_score += 1 if(profile[:type] == 'facebook')
  	end
  	current_record.update(credibility_score: credibility_score) if credibility_score != current_record.credibility_score
  end

  private
  def stubed_data
  	{
			"status": 200,
			"requestId": "e158b690-4c96-4542-bd1a-f5a374580156",
			"likelihood": 0.95,
			"contactInfo": {
				"familyName": "Raphy",
				"fullName": "Renil Raphy",
				"givenName": "Renil"
			},
			"organizations": [{
				"isPrimary": false,
				"name": "Skreem",
				"startDate": "2016-03",
				"title": "Software Developer",
				"current": true
			}, {
				"isPrimary": false,
				"name": "Carettech Cosultancy Ltd",
				"startDate": "2013-10",
				"title": "Junior Software Engineer",
				"current": true
			}],
			"demographics": {
				"locationDeduced": {
					"deducedLocation": "Thrissur, Kerala, India",
					"city": {
						"deduced": false,
						"name": "Thrissur"
					},
					"state": {
						"deduced": false,
						"name": "Kerala"
					},
					"country": {
						"deduced": false,
						"name": "India",
						"code": "IN"
					},
					"continent": {
						"deduced": true,
						"name": "Asia"
					},
					"county": {
						"deduced": true,
						"name": "Thrissur District"
					},

					"likelihood": 1.0
				},
				"gender": "Male",
				"locationGeneral": "Thrissur, Kerala, India"
			},
			"socialProfiles": [{
				"bio": "I am working on Web applications mainly in 'Ruby on Rails', and have knowledge in 'Django' framework too.",
				"followers": 272,
				"following": 272,
				"type": "linkedin",
				"typeId": "linkedin",
				"typeName": "LinkedIn",
				"url": "https://www.linkedin.com/in/renil-raphy-16a35661",
				"username": "renil-raphy-16a35661",
				"id": "218837602"
			}, {
				"followers": 28,
				"following": 34,
				"type": "twitter",
				"typeId": "twitter",
				"typeName": "Twitter",
				"url": "https://twitter.com/renilraphyp100",
				"username": "renilraphyp100",
				"id": "1269251400"
			}]
		}
  end
end


