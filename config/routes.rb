Rails.application.routes.draw do

  get 'welcome' => 'welcome#index'

  get 'rules' => 'rules#index'

  get 'informations' => 'informations#index'

  get 'calendar' => 'calendar#index'
  get 'calendar_for_iframe' => 'calendar#show'

  get 'rankings' => 'rankings#index'

  resources :feedbacks

  resources :tournaments
  post 'tournaments/add_player/:id' => 'tournaments#add_player'
  post 'tournaments/remove_player/:id' => 'tournaments#remove_player'
  post 'tournaments/setup/:id' => 'tournaments#setup'
  post 'tournaments/start/:id' => 'tournaments#start'
  post 'tournaments/finish/:id' => 'tournaments#finish'
  post 'tournaments/cancel/:id' => 'tournaments#cancel'

  get 'players/unregistered' => 'players#unregistered'
  resources :players, except: [:new]

  resources :registrations, only: [:update]

  devise_for :users, controllers: { registrations: 'users/registrations', passwords: 'users/passwords' }
  resources :users, only: [:index, :update, :destroy]

  mount Thredded::Engine => '/forum'

  root to: "welcome#index"

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
