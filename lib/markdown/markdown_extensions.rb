module MarkdownExtension
    class Block < SimpleMarkdown::Converter
        skip_step
        def self.parse(string, converters)
            if start_index = (string =~ /\A#{identifier}\{/)
                inside_block = 1
                index = start_index + string[/\A#{identifier}\{/].length
                end_index = 0
                (index..string.length).each { |i|
                    case string[i]
                    when '{'
                        inside_block += 1
                    when '}'
                        if (inside_block -= 1) == 0
                            end_index = i
                            break
                        end
                    end
                }

                if end_index > 0
                    return execute(string, converters, (start_index..end_index), (index..end_index-1))
                end
            end

            super
        end

        def self.identifier
            ""
        end

        def self.execute(string, converters, block_range, body_range)
            superclass.parse(string, converters)
        end
    end

    class ExecBlock < Block
        place_before(SimpleMarkdown)
        def self.identifier
            /@ruby[[:space:]]*/m
        end

        def self.execute(string, converters, block_range, body_range)
            string[block_range] = eval string[body_range]
            ""
        end
    end

    class StyleBlock < Block
        place_before(SimpleMarkdown)
        def self.identifier
            /@style.*?/m
        end

        def self.execute(string, converters, block_range, body_range)
            styles = string[block_range.min+6..body_range.min-2].split("\n").map! { |style|
                s = style.strip
                if s.length > 0
                    s[-1] == ';' ? s : s << ';'
                end
                s
            }.join
            string[block_range] = "<span style=\"#{styles}\">#{string[body_range]}</span>"
            ""
        end
    end

    class CodeBlock < Block
        place_before(SimpleMarkdown)
        def self.identifier
            /@code:[[:space:]]*.*?/m
        end

        def self.execute(string, converters, block_range, body_range)
            syntax = string[block_range.min+6..body_range.min-2].strip
            highlighted = Rouge.highlight(string[body_range].strip, Rouge::Lexer.find(syntax) || 'text', 'html')
            string[block_range] = ""

            highlighted
        end
    end
end
