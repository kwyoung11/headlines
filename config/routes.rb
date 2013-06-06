NewsHeadlines::Application.routes.draw do
  resources :headlines

  root to: "headlines#index"
end
