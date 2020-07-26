Rails.application.routes.draw do
  root 'users#index'

  devise_for :users

  # в профиле юзера показываем его игры, на главной - список лучших игроков
  resources :users, only: [:index, :show]

  resources :games, only: [:create, :show] do
    # Доп. методы ресурса:
    put 'help', on: :member # помощь зала
    put 'answer', on: :member # ответ на текущий вопрос
    put 'take_money', on: :member #  игрок берет деньги
  end

  # Ресурс в единственном числе, но вопросЫ — для загрузки админом сразу пачки вопросов
  resource :questions, only: [:new, :create]
end
