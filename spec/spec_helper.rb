require 'rspec'
require 'configie/version'

RSpec.configure do |config|
  # use expect syntax only, disable should syntax
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
