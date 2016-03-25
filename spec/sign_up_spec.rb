feature 'during sign up' do

  context 'when form is filled with valid name, email address and password' do
    before do
      sign_up
    end

    scenario 'the User count increases by 1' do
      expect{ click_button('New User') }.to change{ User.all.count }.by(1)
    end

    context 'and clicks "New User"' do
      before do
        click_button('New User')
      end

      scenario 'it displays a welcome message' do
        expect(page).to have_content('Welcome bob')
      end

      scenario 'email address is saved in database' do
        expect(User.last.email).to eq('bob@bob.com')
      end
    end      
  end

  scenario 'it displays a welcome message specific to a user' do
    sign_up(name: 'tom', email: 'tom@tom.com', password: 'tompw', confirm_password: 'tompw')
    click_button('New User')
    expect(page).to have_content('Welcome tom')
  end

  scenario 'it will raise error if passwords do not match' do
    sign_up(name: 'tom', email: 'tom@tom.com', password: 'tompw', confirm_password: 'tomwrongpw')
    click_button('New User')
    expect(page).not_to have_content('tom')
  end

  scenario 'it will not progress if no email address' do
    sign_up(email: nil)
    click_button('New User')
    page.has_xpath?('/')
  end

  context 'when a user is signing up with an already registered email' do
    before do
      sign_up
      click_button('New User')
      visit('/')
      sign_up(name: 'robert', 
              email: 'bob@bob.com', 
              password: 'robertpw', 
              confirm_password: 'robertpw') 
    end

    scenario 'will not add email again to database' do
      expect{ click_button('New User') }.to_not change{ User.all.count }
    end

    scenario 'will display error message' do
      click_button('New User')
      expect(page).to have_content('Email is already taken')
    end
  end
end
