
[![Build Status](https://travis-ci.org/katoy/checkmailtemplate.png?branch=master)](https://travis-ci.org/katoy/checkmailtemplate)
[![Dependency Status](https://gemnasium.com/katoy/checkmailtemplate.svg)](https://gemnasium.com/katoy/checkmailtemplate)
[![Coverage Status](https://coveralls.io/repos/katoy/checkmailtemplate/badge.png)](https://coveralls.io/r/katoy/checkmailtemplate)

# メールテンプレートファイルの生成とチェックのコマンドラインツール

これは、メールテンプレートを作成したり、チェックをするコマンドラインツールである。  
これは thoe と racc の利用例でもある。  

## メールテンプレートの書式

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

TYPE, SUBJ, FROM はこの順番で１つずつ指定する必要がある。  

TO, CC, BCC の指定はオプションである。複数指定が可能。順番は問わない。(FROM と BODY の間に書く事)

BODY の指定は必須。最後に記載すること。  
BODY  の次の行から、ファイルの最後までを本文と見なす。  

## 使用例

    $ bundle exec bin/checkmailtemplates check test/template


    $ bundle exec bin/checkmailtemplates help


# Checkmailtemplate

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'checkmailtemplate'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install checkmailtemplate

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( https://github.com/[my-github-username]/checkmailtemplate/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
