require 'strscan'

module TemplateParser
  class Tokenizer
    def initialize(source)
      @scanner = StringScanner.new(source)
      @state = :bol     # :bol, :document
      @start_doc = false
      @line_no = 1
    end

    def next
      return nil if @scanner.eos?
      send("next_on_state_#{@state}")
    end

    def next_on_state_bol
      case
      when s = @scanner.scan(/TYPE:/)
        return [:TYPE, [@line_no, s]]
      when s = @scanner.scan(/SUBJ:/)
        return [:SUBJ, [@line_no, s]]
      when s = @scanner.scan(/FROM:/)
        return [:FROM, [@line_no, s]]
      when s = @scanner.scan(/TO:/)
        return [:TO, [@line_no, s]]
      when s = @scanner.scan(/CC:/)
        return [:CC, [@line_no, s]]
      when s = @scanner.scan(/BCC:/)
        return [:BCC, [@line_no, s]]
      when s = @scanner.scan(/BODY:/)
        @start_doc = true
        return [:BODY, [@line_no, s]]
      when s = @scanner.scan(/\n/)
        @state = :document if @start_doc
        @line_no += 1
        return [:NL, [@line_no, s]]
      when s = @scanner.scan(/.*/)
        return [:VALUE, [@line_no, s]]
      end
    end

    def next_on_state_document
      case
      when s = @scanner.scan(/.*\n/)
        @line_no += 1
        return [:LINE, [@line_no, s]]
      end
    end
  end
end
