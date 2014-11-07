Rails.application.routes.draw do
  
  # /users
  post    "users" => "users#create"
  get     "users/:user_name" => "users#show"

  # /convos
  post    "convos" => "convos#create"
  patch   "convos/:convo_id" => "convos#update"
  get     "convos" => "convos#index"
  get     "convos/:convo_id" => "convos#show"
  delete  "convos/:convo_id" => "convos#destroy"

end
