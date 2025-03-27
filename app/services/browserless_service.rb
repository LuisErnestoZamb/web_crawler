class BrowserlessService
  include HTTParty
  base_uri = URI.parse(ENV.fetch("BROWSERLESS_DOMAIN", "https://production-sfo.browserless.io"))

  def self.take_screenshot(url, options = {fullPage: true, type: 'png'})
    response = post(
      '/screenshot',
      query: { token: ENV['BROWSERLESS_TOKEN'] },
      headers: {
        'Cache-Control' => 'no-cache',
        'Content-Type' => 'application/json'
      },
      body: {
        url: url,
        options: options
      }.to_json
    )

    if response.success?
      response.body # Return binary image data
    else
      raise "API Error: #{response.code} - #{response.body}"
    end
  end
end