RSpec.configure do |config|
  if config.inclusion_filter.rules.has_key?(:bdd)
    config.before(:suite) do |example|
      expected_keys = [
        ['KLARNA_US_API_KEY', 'KLARNA_US_API_SECRET'],
        ['KLARNA_DE_API_KEY', 'KLARNA_DE_API_SECRET'],
        ['KLARNA_UK_API_KEY', 'KLARNA_UK_API_SECRET'],
        ['KLARNA_SE_API_KEY', 'KLARNA_SE_API_SECRET'],
        ['KLARNA_NO_API_KEY', 'KLARNA_NO_API_SECRET'],
        ['KLARNA_FI_API_KEY', 'KLARNA_FI_API_SECRET']
      ]

      if expected_keys.none?{ |key, secret| ENV[key].present? && ENV[secret].present? }
        raise "Please specify a KLARNA_{COUNTRY_CODE}_API_KEY=xyz KLARNA_{COUNTRY_CODE}_API_SECRET=XYZ in your environment variables for any of the countries."
      end

      Spree::PaymentMethod.where(type: 'Spree::Gateway::KlarnaCredit').destroy_all

      api_key = "KLARNA_#{$store_id.upcase}_API_KEY"
      api_secret = "KLARNA_#{$store_id.upcase}_API_SECRET"
      api_name = "Klarna #{$store_id.upcase}"

      if ENV.has_key?(api_key) && ENV.has_key?(api_secret) && Spree::PaymentMethod.where(name: api_name).none?
        Spree::PaymentMethod.create(
          name: api_name,
          type: 'Spree::Gateway::KlarnaCredit',
          preferences: {
            server: "test",
            test_mode: true,
            api_key: ENV[api_key],
            api_secret: ENV[api_secret],
            country: $store_id.downcase
          })
      end

      if Spree::PaymentMethod.where(name: "Wrong Klarna").none?
        Spree::PaymentMethod.create(
          name: "Wrong Klarna",
          type: 'Spree::Gateway::KlarnaCredit',
          preferences: {
            server: "test",
            test_mode: true,
            api_key: 'wrong_key',
            api_secret: 'and_wrong_secret',
            country: "us"
          })
      end
    end
  end
end
