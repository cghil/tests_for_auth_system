require 'selenium-webdriver'
require 'test/unit'

class Setup < Test::Unit::TestCase
	def setup
		@driver = Selenium::WebDriver.for :firefox
		@wait = Selenium::WebDriver::Wait.new :timeout => 10
	end

	def user_login
		email = "cghilarducci@gmail.com"
		@driver.get ('http://localhost:8000')
		link = @driver.find_element(:link, "Log In")
		link.click()

		email_input = @wait.until do
			email_field = @driver.find_element(:name, "email")
			email_field if email_field.displayed?
		end

		email_input.send_keys(email)

		password_input = @wait.until do
			password_field = @driver.find_element(:name, "password")
			password_field if password_field.displayed?
		end

		password_input.send_keys('12345678')

		submit_button = @driver.find_element(:id, "submit")
		submit_button.click()

		@wait.until do 
			@driver.find_element(:tag_name => "h3").text.include?(email)
		end
		
		url = @driver.current_url
		
	end

	def test_signin
		url = user_login()
		assert_equal(url, "http://localhost:8000/#/users/5")
		puts "User logged in"
	end

	def teardown
		@driver.quit
	end
end