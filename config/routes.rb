Rails.application.routes.draw do
  resources :users
  root to: "users#index"

  get "update_eligibility_status" => "users#update_eligibility_status"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
