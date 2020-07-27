require 'rails_helper'

RSpec.feature 'USER looks another USER profile', type: :feature do
  let(:vasya) { FactoryBot.create :user, name: 'Вася', balance: 213 }
  let(:petya) { FactoryBot.create :user, name: 'Петя' }
  let!(:games) { [
      FactoryBot.create(
          :game,
          user: petya,
          current_level: 10,
          prize: 32000,
          friend_call_used: true,
          is_failed: false,
          created_at: '01.05.2020, 12:00',
          finished_at: Time.now
      ),
      FactoryBot.create(:game, user: petya, current_level: 3, prize: 300)
  ] }

  scenario 'profile observation' do
    login_as vasya

    # заходим на главную
    visit '/'
    # жмём на нужного юзера
    click_link 'Петя'
    # попадем на нужный url
    expect(page).to have_current_path "/users/#{petya.id}"
    # инфа о своём профиле в шапке
    expect(page).to have_content 'Вася'
    expect(page).to have_content '213 ₽'
    # имя другого пользователя
    expect(page).to have_content 'Петя'
    # первая игра
    expect(page).to have_content 'деньги'
    expect(page).to have_content '01 мая, 12:00'
    expect(page).to have_content '10'
    expect(page).to have_content '32 000 ₽'
    # вторая игра
    expect(page).to have_content '3'
    expect(page).to have_content '300 ₽'
    # в чужом профиле этой кнопки быть не должно
    expect(page).not_to have_content 'Сменить имя и пароль'

    save_and_open_page
  end
end
