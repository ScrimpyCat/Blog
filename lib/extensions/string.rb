class String
    REPLACE = /[ :]/
    REMOVE = /[!%#\?]/

    def linkify
        downcase.gsub(REPLACE, '-').gsub(REMOVE, '').gsub(/-{2,}/, '-').gsub(/-\z/, '')
    end
end
