require 'rails_helper'
require 'support/my_spec_helper'

RSpec.describe GamesController, type: :controller do
  # обычный пользователь
  let(:user) { FactoryBot.create(:user) }
  # админ
  let(:admin) { FactoryBot.create(:user, is_admin: true) }
  # игра с прописанными игровыми вопросами
  let(:game_w_questions) { FactoryBot.create(:game_with_questions, user: user) }

  context 'Anon' do
    # Аноним не может смотреть игру
    it 'kicks from #show' do
      # Вызываем экшен
      get :show, id: game_w_questions.id
      # Проверяем ответ
      # статус ответа не равен 200
      expect(response.status).not_to eq(200)
      # Devise должен отправить на логин
      expect(response).to redirect_to(new_user_session_path)
      # Во flash должно быть сообщение об ошибке
      expect(flash[:alert]).to be
    end
  end

  context 'Usual user' do

    # Этот блок будет выполняться перед каждым тестом в группе
    # Логиним юзера с помощью девайзовского метода sign_in
    before(:each) { sign_in user }

    it 'creates game' do
      # Создадим пачку вопросов
      generate_questions(15)

      # Экшен create у нас отвечает на запрос POST
      post :create
      # Вытаскиваем из контроллера поле @game
      game = assigns(:game)

      # Проверяем состояние этой игры: она не закончена
      # Юзер должен быть именно тот, которого залогинили
      expect(game.finished?).to be_falsey
      expect(game.user).to eq(user)
      # Проверяем, есть ли редирект на страницу этой игры
      # И есть ли сообщение об этом
      expect(response).to redirect_to(game_path(game))
      expect(flash[:notice]).to be
    end
  end
end
