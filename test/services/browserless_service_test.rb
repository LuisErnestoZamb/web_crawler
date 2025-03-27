# app/services/browserless_service_test.rb
require "test_helper"
require "minitest/mock"

class BrowserlessServiceTest < ActiveSupport::TestCase
  def setup
    @url = "https://example.com"
    @options = { fullPage: false }
    @browserless_domain = "https://test.browserless.io"
    @browserless_token = "test_token"

    ENV["BROWSERLESS_DOMAIN"] = @browserless_domain
    ENV["BROWSERLESS_TOKEN"] = @browserless_token
  end

  test "take_screenshot returns binary image data on success" do
    # Mock the HTTP response
    mock_response = Minitest::Mock.new
    mock_response.expect(:success?, true)
    mock_response.expect(:body, "binary_image_data")

    # Mock the HTTParty post method
    BrowserlessService.stub(:post, mock_response) do
      result = BrowserlessService.take_screenshot(@url, @options)
      assert_equal "binary_image_data", result, "Should return binary image data"
    end

    # Verify the mock
    mock_response.verify
  end

  test "take_screenshot raises an error on failure" do
    # Mock the HTTP response
    mock_response = Minitest::Mock.new
    mock_response.expect(:success?, false)
    mock_response.expect(:code, 500)
    mock_response.expect(:body, "Internal Server Error")

    # Mock the HTTParty post method
    BrowserlessService.stub(:post, mock_response) do
      error = assert_raises(RuntimeError) do
        BrowserlessService.take_screenshot(@url, @options)
      end
      assert_match "API Error: 500 - Internal Server Error", error.message
    end

    # Verify the mock
    mock_response.verify
  end
end
