require 'spec_helper'
require './data_mapper_setup'

feature 'User sign up' do

  scenario 'I can sign up as a new user' do
    expect { sign_up }.to change(User, :count).by(1)
    expect(page).to have_content('Welcome, alice@example.com')
    expect(User.first.email).to eq('alice@example.com')
  end

  context 'when filling in form' do
    scenario 'both email and password must have content' do
      visit '/users/new'
      click_button 'Sign up'
      expect(page).to have_content 'Please sign up'
    end

    scenario 'user not created when email left blank' do
      visit '/users/new'
      fill_in 'password', with: 'blahpassword'
      fill_in 'password_confirmation', with: 'blahpassword'
      click_button 'Sign up'
      expect(User.count).to eq 0
    end

    scenario 'requires a matching confirmation password' do
      expect { sign_up(:password_confirmation => 'wrong') }.not_to change(User, :count)
    end

    scenario 'with a password that does not match' do
      expect {sign_up(password_confirmation: 'wrong')}.not_to change(User, :count)
      expect(current_path).to eq('/users')
      expect(page).to have_content 'Password and confirmation password do not match'
    end
  end
end

def sign_up(email: 'alice@example.com',
            password: '12345678',
            password_confirmation: '12345678')
  visit '/users/new'
  fill_in :email, with: email
  fill_in :password, with: password
  fill_in :password_confirmation, with: password_confirmation
  click_button 'Sign up'
end

