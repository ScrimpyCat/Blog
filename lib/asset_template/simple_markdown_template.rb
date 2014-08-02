module AssetTemplate
    class SimpleMarkdownTemplate < Tilt::Template
        self.default_mime_type = 'text/html'
        # self.metadata[:mime_type] = 'text/html'

        def prepare
            load 'markdown_extensions.rb'
        end

        def evaluate(scope, locals, &block)
            SimpleMarkdown.convert(data)
        end

        def allows_script?
            false
        end
    end
end
