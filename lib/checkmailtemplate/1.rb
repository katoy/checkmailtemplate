# coding: UTF-8

require './template_parser'
require './tokenizer'
require './consts.rb'

require 'pry'
require 'awesome_print'

parser = TemplateParser::Parser.new

begin
  src = DATA.read

  ap parser.parse(src)
rescue => e
  puts e
end

__END__
TYPE: type-0
SUBJ: メールのタイトル
FROM: my@example.com
TO:   to_001@example.com
TO:   to_002@example.com
CC:   cc_001@example.com
CC:   cc_002@example.com
BCC:  bcc_001@example.com
BCC:  bcc_002@example.com
BODY:
メールの本文
