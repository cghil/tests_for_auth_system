require 'selenium-webdriver'

driver = Selenium::WebDriver.for:firefox

# driver.navigate.to("http://www.assertselenium.com")

driver.get("http://localhost:8000");

link = driver.find_element(:link, "Log In")
link.click()

wait = Selenium::WebDriver::Wait.new(:timeout => 15)

email_input = wait.until {
	email_field = driver.find_element(:name, "email")
	email_field if email_field.displayed?
}

email_input.send_keys('cghilarducci@gmail.com')

password_input = wait.until {
	password_field = driver.find_element(:name, "password")
	password_field if password_field.displayed?
}

password_input.send_keys('12345678')

submit_button = driver.find_element(:id, "submit")
submit_button.click()

puts driver.current_url

