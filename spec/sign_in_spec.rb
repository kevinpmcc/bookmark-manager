feature 'signing in' do

  scenario 'a registered user can sign in with email address and password' do
    sign_up
    click_button('New User')
    visit('/')
    fill_in :login_email, with: 'bob@bob.com'
    fill_in :login_password, with: 'bobpw'
    click_button('Login')
    expect(page).to have_content('Welcome bob')
  end
end
