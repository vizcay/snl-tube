require 'rails_helper'

RSpec.feature 'Visitor signs in', js: true, vcr: true do
  before :each do
    visit root_path
  end

  scenario 'with invalid credentials' do
    click_on 'Visitor'
    click_on 'Sign in'

    fill_in 'Email', with: 'not@valid.com'
    fill_in 'Password', with: 'password'
    click_on 'Sign in'

    expect(page).to have_content('Invalid username or password')
  end
end
