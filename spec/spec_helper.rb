# -*- coding: utf-8 -*-

require 'stringio'
require 'pry'
require 'awesome_print'

require 'simplecov'
require 'simplecov-rcov'

require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
                                                           SimpleCov::Formatter::RcovFormatter,
                                                           SimpleCov::Formatter::HTMLFormatter,
                                                           Coveralls::SimpleCov::Formatter
                                                          ]
SimpleCov.start

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
end

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'checkmailtemplate'

# See http://qiita.com/gokoku_h/items/5e6903a240abc8a5cac6
def capture(stream)
  begin
    stream = stream.to_s
    eval "$#{stream} = StringIO.new"
    yield
    result = eval("$#{stream}").string
  ensure
    eval "$#{stream} = #{stream.upcase}"
  end
  result
end
