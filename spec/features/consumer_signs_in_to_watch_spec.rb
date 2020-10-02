require 'rails_helper'

RSpec.feature 'Consumer signs in to watch', js: true, vcr: true do
  before :each do
    travel_to Date.new(2020, 10, 1)
    visit root_path
  end

  scenario 'Consumer visits premium video, signs in successfully and is entitled to watch to it' do
    click_on 'Teacher Trial with Ronda Rousey - SNL'
    expect(page).to have_content('This is premium content!')
    expect(page).to have_content('Please sign in to continue')

    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: 'password'
    click_on 'Sign in'
    expect(page).to have_current_path(show_video_path(id: '56a7b83069702d2f8306d9b7'))
    expect(page).to have_content('test@test.com')
    expect(page).to have_content('Teacher Trial with Ronda Rousey - SNL')
    expect(page).to have_css('iframe[src="https://www.youtube.com/embed/m6uvv1aS5_I"]')
  end

  scenario 'Consumer visits premium video, signs in successfully and is not entitled to watch to it' do
    click_on 'Teacher Trial with Ronda Rousey - SNL'
    expect(page).to have_content('This is premium content!')
    expect(page).to have_content('Please sign in to continue')

    fill_in 'Email', with: 'test2@test.com'
    fill_in 'Password', with: 'password'
    click_on 'Sign in'

    expect(page).to have_content('A subscription must be purchased to watch premium content!')
  end

  scenario 'Consumer signs in via index page and returns to it' do
    click_on 'Visitor'
    click_on 'Sign in'

    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: 'password'
    click_on 'Sign in'

    expect(page).to have_current_path(videos_path)
    expect(page).to have_content('test@test.com')
  end

  scenario 'Consumer signs in and out' do
    click_on 'Visitor'
    click_on 'Sign in'

    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: 'password'
    click_on 'Sign in'

    expect(page).to have_current_path(videos_path)
    click_on 'test@test.com'
    accept_confirm('Exit session?') do
      click_on 'Sign out'
    end
    expect(page).to have_content('Visitor')
  end
end
