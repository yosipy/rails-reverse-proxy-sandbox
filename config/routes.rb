Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  match 'blog/(*path)' => 'wordpress#index', via: [:get, :post, :put, :patch, :delete]
end
