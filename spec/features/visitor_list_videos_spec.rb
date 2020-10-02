require 'rails_helper'

RSpec.feature 'Visitor views list of videos on homepage', js: true, vcr: true do
  before :each do
    visit root_path
  end

  scenario 'Visitor views list of free and premium videos with thumbnail and title' do
    within '.video-0' do
      expect(page).to have_content('Teacher Trial with Ronda Rousey - SNL')
      expect(page).to have_css('img[src="https://image.zype.com/56a7b4a369702d1927000000/' +
                               '56a7b83069702d2f8306d9b7/custom_thumbnail/240.jpg?1507608803"]')
      expect(page).to have_content('Premium')
    end
    within '.video-2' do
      expect(page).to have_content('Bland Man - SNL')
      expect(page).to have_css('img[src="https://image.zype.com/56a7b4a369702d1927000000/' +
                               '56a7b83069702d2f8312d9b7/custom_thumbnail/240.jpg?1507643556"]')
      expect(page).not_to have_content('Premium')
    end
  end

  scenario 'Visitor views videos ordered by most recent published time' do
    within '.video-0' do
      expect(page).to have_content('Teacher Trial with Ronda Rousey - SNL')
    end
    within '.video-1' do
      expect(page).to have_content('Palin Endorsement Cold Open - SNL')
    end
    within '.video-8' do
      expect(page).to have_content('SNL Host Ronda Rousey and Selena Gomez Call Boys with Cecily Strong')
    end
  end

  scenario 'Visitor clicks free video and is allowed to play it' do
    click_on 'Bland Man - SNL'
    expect(page).to have_current_path(show_video_path(id: '56a7b83069702d2f8312d9b7'))
    expect(page).to have_content('Bland Man - SNL')
    expect(page).to have_css('iframe[src="https://www.youtube.com/embed/JDy3E05gLMc"]')
  end

  scenario 'Visitor clicks premium video and is asked to sign in' do
    click_on 'Teacher Trial with Ronda Rousey - SNL'
    expect(page).to have_content('This is premium content!')
    expect(page).to have_content('Please sign in to continue')
  end
end
