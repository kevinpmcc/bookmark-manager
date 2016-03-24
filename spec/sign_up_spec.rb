feature 'after signing up' do

  scenario 'the User count increases by 1' do
    sign_up_bob
    expect{ click_button('New User') }.to change{ User.all.count }.by(1)
  end

  scenario 'page displays a welcome message' do
    sign_up_bob
    click_button('New User')
    expect(page).to have_content('Welcome Bob!')
  end

  scenario 'page displays a welcome message specific to a user' do
    sign_up_tom
    click_button('New User')
    expect(page).to have_content('Welcome Tom!')
  end

  scenario 'email address is saved in database' do
    sign_up_tom
    click_button('New User')
    expect(User.last.email).to eq('tom@tom.com')
  end
  
  scenario 'will raise error if passwords do not match' do
    sign_up_tom
    fill_in('confirm_password', :with => 'wrongpassword')     
    click_button('New User')
    expect(page).not_to have_content('Tom')
  end
end
