Feature: User Authentication
  As a user
  I want to be able to log in with my Northwestern email
  So that I can access my saved courses and preferences

  Background:
    Given I am on the login page

  Scenario: Successful login with Northwestern email
    Given I have a valid Google account with Northwestern email
    When I click "Sign in with Google"
    And I authorize the application
    Then I should be redirected to the saved classes page
    And I should see my email address in the navbar
    And I should see my profile picture in the navbar

  Scenario: Failed login with non-Northwestern email
    Given I have a Google account with non-Northwestern email
    When I click "Sign in with Google"
    And I authorize the application
    Then I should remain on the login page
    And I should see an error message about using a Northwestern email 