Rails.application.routes.draw do

  get 'welcome' => 'welcome#index'

  Rails.application.config.default_locales.each do |locale|
    get "welcome/index_#{locale[0].to_s}" => redirect("/welcome?locale=#{locale[1]}")
  end

  get 'rules' => 'rules#index'

  get 'informations' => 'informations#index'

  get 'calendar' => 'calendar#index'
  get 'calendar_for_iframe' => 'calendar#show'

  get 'character_skins' => 'character_skins#show'

  post 'contact' => 'contact#contact'

  get 'donations' => 'donations#index'
  post 'donation' => 'donations#donation'

  get 'rankings' => 'rankings#index'

  get 'streams' => 'streams#index'

  get 'statistics' => 'statistics#index'

  get 'videos' => 'videos#index'

  # DE routes:
  get 'communities' => 'communities#index'
  get 'communities/nrw' => 'communities#nrw'
  get 'communities/hessen' => 'communities#hessen'
  get 'communities/nds' => 'communities#nds'
  get 'communities/bayern' => 'communities#bayern'
  get 'communities/berlin' => 'communities#berlin'
  get 'communities/norden' => 'communities#norden'
  get 'communities/osten' => 'communities#osten'
  get 'communities/bawu' => 'communities#bawu'

  # FR & IT routes:
  get "/communities/regions/:name" => "communities#regions"
  get "/communities/character_discords" => "communities#character_discords"
  resources :communities

  # PT routes:
  get 'locus_league' => 'locus_league#index'

  resources :teams
  post 'teams/add_player/:id' => 'teams#add_player'
  post 'teams/remove_player/:id' => 'teams#remove_player'

  resources :news
  resources :feedbacks
  # get 'administrators' => 'administrators#index'
  get 'imprint' => 'imprint#index'
  get 'privacy_policy' => 'privacy_policy#index'

  resources :tournaments
  post 'tournaments/add_player/:id' => 'tournaments#add_player'
  post 'tournaments/remove_player/:id' => 'tournaments#remove_player'
  post 'tournaments/setup/:id' => 'tournaments#setup'
  post 'tournaments/start/:id' => 'tournaments#start'
  post 'tournaments/finish/:id' => 'tournaments#finish'
  post 'tournaments/cancel/:id' => 'tournaments#cancel'
  patch 'tournaments/sort_players/:id' => 'tournaments#sort_players'
  patch 'tournaments/seed_players/:id' => 'tournaments#seed_players'

  get 'players/unregistered' => 'players#unregistered'
  post 'players/export/:id' => 'players#export'
  resources :players, except: [:new]

  resources :registrations, only: [:update]

  resources :survey_responses, only: [:create, :update]

  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions', passwords: 'users/passwords' }
  resources :users, only: [:index, :update, :destroy]

  mount Thredded::Engine => '/thredded'
  get 'forum' => 'forum#index'

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
