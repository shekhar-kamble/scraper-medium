Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'blogs#home'
  post 'blogs/:tag' => 'blogs#scrapByTag'
  get 'blogs/:tag' => 'blogs#scrapMore'
end
