require 'selenium-webdriver'
require 'test/unit'

class UserTests < Test::Unit::TestCase
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

	def clickEditUserBtn
		user_login()
		editButton = @driver.find_element(:name, 'show-edit-form-button')
		editButton.click()
	end


	def test_signin
		url = user_login()
		assert_equal(url, "http://localhost:8000/#/users/5")
	end

	def test_edit_user_password_errors
		clickEditUserBtn()

		password_input = @wait.until do
			password_field = @driver.find_element(:name, 'password')
			password_field if password_field.displayed?
		end

		password_input.send_keys('hello')

		errors = @driver.find_element(:id, 'errors')
		assert_equal(errors.displayed?, true)
		assert(errors.text.include?("Password must contain number!"))
		assert(errors.text.include?('Password is too short'))

	end

	def test_edit_user_password_confirmation_errors
		clickEditUserBtn()
		
		password_input = @wait.until do
			password_field = @driver.find_element(:name, 'password')
			password_field if password_field.displayed?
		end

		password_input.send_keys('87654321')

		password_confirmation_input = @wait.until do
			password_confirmation_field = @driver.find_element(:name, 'passwordConfirmation')
			password_confirmation_field if password_confirmation_field.displayed?
		end

		errors = @driver.find_element(:id, 'errors')

		password_confirmation_input.send_keys('543210')
		assert(errors.text.include?("Password confirmation is too short"))
		assert(errors.text.include?("Passwords do NOT match"))

		@wait.until do
			password_confirmation_input.clear()
			password_confirmation_input.send_keys('87654321')
		end

		assert_equal(errors.displayed?, false)
	end

	def teardown
		@driver.quit
	end
end