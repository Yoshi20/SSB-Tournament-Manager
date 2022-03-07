Rails.application.routes.draw do

  get 'welcome' => 'welcome#index'

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

  # FR routes:
  get 'guides' => 'guides#index'
  get "/communities/grand_est" => "communities#grand_est"
  get "/communities/nouvelle_aquitaine" => "communities#nouvelle_aquitaine"
  get "/communities/auvergne_rhone_alpes" => "communities#auvergne_rhone_alpes"
  get "/communities/bourgogne_franche_comte" => "communities#bourgogne_franche_comte"
  get "/communities/bretagne" => "communities#bretagne"
  get "/communities/centre_val_de_loire" => "communities#centre_val_de_loire"
  get "/communities/corsica" => "communities#corsica"
  get "/communities/paris_region" => "communities#paris_region"
  get "/communities/occitanie" => "communities#occitanie"
  get "/communities/hauts_de_france" => "communities#hauts_de_france"
  get "/communities/normandie" => "communities#normandie"
  get "/communities/pays_de_la_loire" => "communities#pays_de_la_loire"
  get "/communities/provence_alpes_cote_azur" => "communities#provence_alpes_cote_azur"
  # get "/communities/reunion" => "communities#reunion"
  # get "/communities/martinique" => "communities#martinique"
  # get "/communities/french_guiana" => "communities#french_guiana"
  # get "/communities/guadeloupe" => "communities#guadeloupe"
  # get "/communities/mayotte" => "communities#mayotte"
  get "/communities/character_discords" => "communities#character_discords"
  resources :communities

  resources :news
  resources :feedbacks
  get 'administrators' => 'administrators#index'
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
  resources :players, except: [:new]

  resources :registrations, only: [:update]

  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions', passwords: 'users/passwords' }
  resources :users, only: [:index, :update, :destroy]

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
