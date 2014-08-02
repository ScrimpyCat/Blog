module AssetTemplate
    class PostTemplate < Tilt::Template
        MATCH = /\A\s*-{3}.*?-{3}\n?/m

        def self.extract_info(data)
            YAML.load(data[MATCH] || '') || {}
        end

        self.default_mime_type = 'text/html'
        # self.metadata[:mime_type] = 'text/html'

        def prepare
        end

        def evaluate(scope, locals, &block)
            data.sub(MATCH, '')
        end

        def allows_script?
            false
        end
    end
end
