feature 'filtering tags' do
  scenario 'when user select tag to filter links by' do

    create_makers_link

    visit('/links')
    click_button('New Link')
    fill_in :title, with: 'Makers Bubbles'
    fill_in :url, with: 'http://www.makersacademy.co.uk'
    fill_in :tags, with: 'bubbles'
    click_button('Submit Link')

    visit'/tags/bubbles'

    within 'ul#links' do
      expect(page).to have_content('Makers Bubbles')
      expect(page).not_to have_content('Makers Academy')
    end
  end
end
