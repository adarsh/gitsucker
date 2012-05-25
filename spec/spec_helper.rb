$LOAD_PATH << File.expand_path('../lib', __FILE__)

require 'gitsucker'
require 'sham_rack'

Dir['spec/support/**/*.rb'].each { |f| require File.expand_path(f) }

RSpec.configure do |c|
  c.mock_with :mocha

  c.after do
    ShamRack.unmount_all
  end
end
