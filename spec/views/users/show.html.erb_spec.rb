require 'rails_helper'

RSpec.describe 'users/show', type: :view do
  let(:user) { FactoryBot.create(:user, name: 'Юра') }

  before(:each) do
    assign(:user, user)
    assign(:games, [''])
    stub_template 'users/_game.html.erb' => 'User game goes here'
    render
  end

  it 'renders player name' do
    expect(rendered).to match 'Юра'
  end

  it 'renders change password button for current user' do
    expect(rendered).not_to match 'Сменить имя и пароль'
    sign_in user
    render
    expect(rendered).to match 'Сменить имя и пароль'
  end

  it 'renders game partial' do
    expect(rendered).to match 'User game goes here'
  end
end
