# -*- coding: utf-8 -*-

require 'spec_helper'

describe Checkmailtemplate do
  it 'has a version number such as "0.0.1"' do
    expect(Checkmailtemplate::VERSION).to match /\d+\.\d+\.\d+/
  end

  it 'help message has "help", "version"' do
    content = capture(:stdout) do
      Checkmailtemplate::Command.new.invoke(:help)
    end
    expect(content).to match /\shelp\s/
    expect(content).to match /\sversion\s/
  end

  it 'run "version"' do
    content = capture(:stdout) do
      Checkmailtemplate::Command.new.invoke(:version)
    end
    expect(content).to eq("#{Checkmailtemplate::VERSION}\n")
  end

  it 'run "generate"' do
    content = capture(:stdout) do
      system('mkdir tmp')
      Checkmailtemplate::Command.new.invoke(:generate, ['tmp/1.txt'], color: false)
    end
    expect(content).to eq('')
    src = File.read('tmp/1.txt')
    expect(src).to eq(sample_template)
    system('rm -fr tmp')
  end

  it 'run "generate to no-writable"' do
    content = capture(:stderr) do
      begin
        Checkmailtemplate::Command.new.invoke(:generate, ['test/no-exist/tmplate.txt'], color: false)
      rescue SystemExit => ex
        # exit 1 であることをチェック
        expect(ex.status).to eq(1)
      end
    end
    expect(content).to eq("E9003: test/no-exist/tmplate.txt: アクセスできません。\n")
  end

  it 'run "generate to no-readable"' do
    content = capture(:stderr) do
      begin
        system('chmod -x test/no-readable')
        Checkmailtemplate::Command.new.invoke(:generate, ['test/no-readable/tmplate.txt'], color: false)
      rescue SystemExit => ex
        # exit 1 であることをチェック
        expect(ex.status).to eq(1)
      end
    end
    system('chmod +x test/no-readable')
    expect(content).to eq("E9003: test/no-readable/tmplate.txt: アクセスできません。\n")
  end

  it 'run "generate to exists file"' do
    content = capture(:stderr) do
      begin
        Checkmailtemplate::Command.new.invoke(:generate, ['test/templates/template_001.txt'], color: false)
      rescue SystemExit => ex
        # exit 1 であることをチェック
        expect(ex.status).to eq(1)
      end
    end
    expect(content).to eq("E9001: test/templates/template_001.txt: 既にファイルが存在しています。\n")
  end

  it 'checking file.' do
    content = capture(:stderr) do
      Checkmailtemplate::Command.new.invoke(:check, ['test/templates/template_001.txt'], color: false)
    end
    expect(content).to eq('')
  end

  it 'exit 1 for checking no-exist file.' do
    content = capture(:stderr) do
      begin
        Checkmailtemplate::Command.new.invoke(:check, ['test/no-exist'], color: false)
      rescue SystemExit => ex
        # exit 1 であることをチェック
        expect(ex.status).to eq(1)
      end
    end
    expect(content).to eq("E9002: test/no-exist:  存在しません。\n")
  end

  it 'run "check for no-readable"' do
    content = capture(:stderr) do
      begin
        Checkmailtemplate::Command.new.invoke(:check, ['test/templates/template_003_cannot_read.txt'], color: false)
      rescue SystemExit => ex
        # exit 1 であることをチェック
        expect(ex.status).to eq(1)
      end
    end
    expect(content).to eq("E9003: test/templates/template_003_cannot_read.txt: アクセスできません。\n")
  end

  it 'exit 1 for checking no-exist file with --color' do
    content = capture(:stderr) do
      begin
        Checkmailtemplate::Command.new.invoke(:check, ['test/no-exist'])
      rescue SystemExit => ex
        # exit 1 であることをチェック
        expect(ex.status).to eq(1)
      end
    end
    expect(content).to eq("\e[0;31;49mE9002: test/no-exist:  存在しません。\e[0m\n")
  end

  it 'exit 1 for checking folder include invalid files.' do
    content = capture(:stderr) do
      begin
        Checkmailtemplate::Command.new.invoke(:check, ['test/templates'], color: false)
      rescue SystemExit => ex
        # exit 1 であることをチェック
        expect(ex.status).to eq(1)
      end
    end

    str = <<'EOS'
E9010: test/templates/sub1/template_001_empty.txt:0  TYPE: が指定されていません。
E9010: test/templates/sub1/template_002_no_type.txt:1 SUBJ: TYPE: が指定されていません。
E9011: test/templates/sub1/template_003_no_subj.txt:2 FROM: SUBJ: が指定されていません。
E9012: test/templates/sub1/template_004_no_from.txt:3 TO: FROM: が指定されていません。
E9013: test/templates/sub1/template_009_no_body.txt:10 メールの本文 BODY: が指定されていません。
E9005: test/templates/template_002_sjis.txt: ファイルの ecndoing が utf8 でありません。Shift_JIS と判定しました。
E9003: test/templates/template_003_cannot_read.txt: アクセスできません。
E9004: test/templates/template_004.png: ファイル内容が binary です。
EOS
    # エラーメッセージをチェック
    expect(content).to eq(str)
  end
end
