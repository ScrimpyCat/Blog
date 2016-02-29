class String
    REPLACE = /[ :]/
    REMOVE = /[!%#\?]/

    def linkify
        downcase.gsub(/ & /, ' and ').gsub(REPLACE, '-').gsub(REMOVE, '').gsub(/-{2,}/, '-').gsub(/-\z/, '')
    end
end
