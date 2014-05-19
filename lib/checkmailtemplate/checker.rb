# -*- coding: utf-8 -*-
require 'colorize'
require 'charlock_holmes'

def check_templates(path, color = true)
  fail Errno::ENOENT unless File.exist?(path)
  if File.ftype(path) == 'directory'
    check_folder(path, color)
  else
    check_file(path, color)
  end
rescue Errno::ENOENT
  puts_warn "#{format(get_message(:NO_EXIST_1), path)}", color
  false
rescue Errno::EACCES
  puts_warn "#{format(get_message(:NO_ACCESS_1), path)}", color
  false
rescue => ex
  puts ex.backtrace
  puts_warn "#{format(get_message(:ERROR_3), path, ex.class, ex)}", color
  false
end

def check_folder(path, color)
  ans = true
  Dir.glob("#{path}/**/*").each do |f|
    if File.ftype(f) == 'file'
      ret = check_file(f, color)
      ans = false unless ret
    end
  end
  ans
end

def check_file(path, color)
  fail Errno::ENOENT unless File.exist?(path)

  src = File.read(path)
  detection = CharlockHolmes::EncodingDetector.detect(src)
  # puts "#{detection[:encoding]} #{detection[:type]} #{path}"
  fail(ArgumentError, format(get_message(:BAD_TYPE_1), detection[:type])) if detection[:type] != :text
  fail(ArgumentError, format(get_message(:BAD_ENCODING_1), detection[:encoding])) if detection[:encoding] != 'UTF-8'
  parser = TemplateParser::Parser.new
  template = parser.parse(src)
  # puts template
  true
rescue Errno::ENOENT
  puts_warn "#{format(get_message(:NO_EXIST_1), path)}", color
  false
rescue Errno::EACCES
  puts_warn "#{format(get_message(:NO_ACCESS_1), path)}", color
  false
rescue ArgumentError => ex
  puts_warn "#{format(ex.message, path)}", color
  false
rescue Racc::ParseError => ex
  puts_warn "#{format(ex.message, path)}", color
  false
rescue => ex
  puts_warn "#{format(get_message(:ERROR_3), path, ex.class, ex)}", color
  false
end

def sample_template
  <<"EOS"
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
EOS
end

def write_template(path, color)
  begin
    fail Errno::EEXIST if File.exist?(path)
    open(path, 'w') { |f| f.write sample_template }
  rescue Errno::EEXIST
    puts_warn "#{format(get_message(:EXIST_1), path)}", color
    false
  rescue Errno::ENOENT
    puts_warn "#{format(get_message(:NO_ACCESS_1), path)}", color
    false
  rescue Errno::EACCES
    puts_warn "#{format(get_message(:NO_ACCESS_1), path)}", color
    false
  rescue => ex
    puts ex.backtrace
    puts_warn "#{format(get_message(:ERROR_3), path, ex.class, ex)}", color
    false
  end
  true
end

# stdout へ出力する
def puts_warn(str, color = true)
  if color
    color_opt = { color: :red }
    warn str.colorize(color_opt)
  else
    warn str
  end
end
