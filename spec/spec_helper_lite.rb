ROOT = File.expand_path("../", File.dirname(__FILE__))
Dir["#{ROOT}/spec/support/**/*.rb"].each { |f| require f }

require "factory_girl"
FactoryGirl.find_definitions

require "paperclip"
Paperclip.options[:log] = false

require "debugger"

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include UnitSpecHelpers
  config.include NullDBSpecHelpers
end
