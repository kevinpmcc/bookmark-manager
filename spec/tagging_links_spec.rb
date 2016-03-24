
feature 'adding tags' do

  scenario 'when we are creating new links' do
    create_makers_link
    link = Link.first
    expect(link.tags.map(&:name)).to include('coding')
  end

  scenario 'when we creating new links with multiple tags'do
    visit('/links')
    click_button('New Link')
    fill_in :title, with: 'Makers Academy'
    fill_in :url, with: 'http://www.makersacademy.co.uk'
    fill_in :tags, with: 'coding,makers'
    click_button('Submit Link')
    link = Link.first
    expect(link.tags.map(&:name)).to include('coding','makers')
  end
end
