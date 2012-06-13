Feature: Manage Video Streams
    In order to make videos available to courses
    As an admin
    I want to create and manage video items

    Scenario: Display a Video Record
        Given I have a video titled Godfather
        When I go to the pertinent video page
        Then I should see "Godfather"
