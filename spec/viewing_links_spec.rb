feature 'view links' do

  scenario 'user can see list of links' do
      Link.create(
      :title => 'Google',
      :url => 'http://google.com'
      )
      visit '/links'
      expect(page.status_code).to eq 200

      within 'ul#links' do
        expect(page).to have_content('Google')
      end
  end
end
