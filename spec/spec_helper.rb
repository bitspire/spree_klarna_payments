$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
ENV['RAILS_ENV'] = 'test'

begin
  require File.expand_path("../dummy/config/environment.rb",  __FILE__)
  ENV["RAILS_ROOT"] ||= File.dirname(__FILE__) + "../../../spec/dummy"
rescue LoadError
  puts "Could not load dummy application. Please ensure you have run `bundle exec rake common:test_app`"
end

require "pry"
require "awesome_print"

require 'spree/core/version'
require 'rails/all'
require 'rspec/rails'
require 'klarna_gateway'
require 'devise'

# Feature specs
require 'capybara'
require 'capybara/rspec'
require 'capybara/rails'
require 'capybara/poltergeist'

require 'vcr'
require 'ffaker' # Spree < 3.2 uses old FFaker that internally exposes class Faker. This forces proper loading.
require 'spree/testing_support/factories'
require 'spree/testing_support/controller_requests'
require 'spree/testing_support/authorization_helpers'
require 'factories/klarna_payment_factory'
require 'support/klarna_api_helper'
require 'support/site_prism'
require 'config/database_cleaner'
require 'config/capybara'
require 'config/vcr'
require 'config/stock_items_provision'

require 'spree_sample'

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.include FactoryGirl::Syntax::Methods
  config.include Spree::TestingSupport::ControllerRequests, type: :controller
  config.include Devise::TestHelpers, :type => :controller
  config.include_context "Klarna API helper", :klarna_api
end
