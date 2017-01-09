require 'integration_test_helper'

class WelcomeTest < ActionDispatch::IntegrationTest
    walk(walk_controller_matcher('welcome'))
end