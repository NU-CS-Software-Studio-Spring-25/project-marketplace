require 'webmock/cucumber'

# Background step
Given("I am on the login page") do
  visit login_path
end

# Successful login scenario steps
Given("I have a valid Google account with Northwestern email") do
  # Mock the OmniAuth response for a successful login
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
    provider: 'google_oauth2',
    uid: '123456789',
    info: {
      email: 'test@u.northwestern.edu',
      name: 'Test User',
      image: 'https://example.com/profile.jpg'
    }
  })
end

When("I click {string}") do |button_text|
  # Instead of clicking the button directly visit the callback URL
  visit '/auth/google_oauth2/callback'
end

And("I authorize the application") do
end

Then("I should be redirected to the saved classes page") do
  expect(current_path).to eq(saved_classes_path)
end

And("I should see my email address in the navbar") do
  expect(page).to have_content('test@u.northwestern.edu')
end

And("I should see my profile picture in the navbar") do
  expect(page).to have_css('img[src="https://example.com/profile.jpg"]')
end

# Failed login scenario steps
Given("I have a Google account with non-Northwestern email") do
  # Mock the OmniAuth response for a non-Northwestern email
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
    provider: 'google_oauth2',
    uid: '987654321',
    info: {
      email: 'test@gmail.com',
      name: 'Test User',
      image: 'https://example.com/profile.jpg'
    }
  })
end

Then("I should remain on the login page") do
  expect(current_path).to eq(login_path)
end

And("I should see an error message about using a Northwestern email") do
  expect(page).to have_content("Please log in with your u.northwestern.edu account")
end 