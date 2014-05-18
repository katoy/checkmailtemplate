# coding: UTF-8

# racc template_parser.y -o template_parser.rb

class TemplateParser::Parser
rule
  program     : type subj from adds body
  type        : TYPE value NL
              { @template[:TYPE] = val[1][1] }
  subj        : SUBJ value NL
              { @template[:SUBJ] = val[1][1] }
  from        : FROM value NL
              { @template[:FROM] = val[1][1] }
  adds       :
              | adds add
  add        : key value NL
              {
                k, v = [val[0][1].to_sym, v = val[1][1]]
                @template[k] = [] unless @template[k]
                @template[k] << v.strip
              }
  key         : TYPE | SUBJ | FROM | TO | CC | BCC
  value       : VALUE

  body        : BODY NL document
              { @template[:BODY] = @document }
  document    :
              | document LINE
              { @document += val[1][1] }
---- inner
  def initialize
    @template = {}
    @document = ''
  end

  def parse(str)
    @tokenizer = TemplateParser::Tokenizer.new(str)
    do_parse
    @template
  end

  def next_token
    @tokenizer.next
  end

  def on_error(t, v, values)
    line = 0
    token = ''
    line = v[0]  if v[0] != '$'
    token = v[1] if v[1]
    msg = check_require(line, token)
    raise Racc::ParseError, msg
  end

  def check_require(line, v)
    return sprintf(get_message(:BAD_TYPE_2), line, v) unless @template[:TYPE]
    return sprintf(get_message(:BAD_SUBJ_2), line, v) unless @template[:SUBJ]
    return sprintf(get_message(:BAD_FROM_2), line, v) unless @template[:FROM]
    return sprintf(get_message(:BAD_BODY_2), line, v) unless @template[:BODY]
    ''
  end
