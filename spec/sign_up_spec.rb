feature 'after signing up' do

  before do
    sign_up
  end
   
  scenario 'the User count increases by 1' do      
    expect{ click_button('New User') }.to change{ User.all.count }.by(1)
  end

  scenario 'page displays a welcome message' do
  end

  scenario 'email address is saved in database' do
  end
end
