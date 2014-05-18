# -*- coding: utf-8 -*-
require 'checkmailtemplate'
require 'thor'

module Checkmailtemplate
  class Command < Thor
    class_option :version, type: :boolean, desc: 'version'
    class_option :color, type: :boolean, default: true
    default_task :help

    desc 'version', 'version'
    def version
      puts Checkmailtemplate::VERSION
    end

    desc 'check path', '指定されたファイルの書式をチェックします。'
    def check(path) # コマンドをメソッドとして定義する
      ret = check_templates(path, options[:color])
      exit 1 unless ret
    end

    desc 'generate path', 'テンプレートファイルの雛形を作成します。'
    def generate(path) # コマンドをメソッドとして定義する
      write_template(path, options[:color])
    end
  end
end
