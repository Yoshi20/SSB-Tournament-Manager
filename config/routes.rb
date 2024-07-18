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

  namespace :shop do
    resource :shopping_cart, only: [:show, :destroy]
    get 'checkout', to: 'orders#new', as: 'checkout'
    resources :orders, only: [:index, :edit, :create, :update, :destroy] # :new -> checkout
    patch 'products/:id/move_down', to: 'products#move_down', as: 'product_move_down'
    resources :products, only: [:new, :edit, :create, :update, :destroy]
    resources :purchases, only: [:index, :create, :update, :destroy]
    namespace :stripe do
      get 'checkout', to: 'checkouts#checkout'
      get 'checkout_success', to: 'checkouts#success'
      get 'checkout_cancel', to: 'checkouts#cancel'
      post 'webhook', to: 'webhooks#webhook'
      get 'account_link', to: 'accounts#account_link'
      get 'account_return', to: 'accounts#return'
      get 'account_refresh', to: 'accounts#refresh'
    end
  end
  get 'shop', to: 'shop#index'

  root to: "welcome#index"

end
