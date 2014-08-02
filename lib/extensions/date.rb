class Time
    def self.at_timestamp(timestamp = '', unit = :milliseconds)
        case unit
        when :nanoseconds
            timestamp = timestamp.gsub(/_/, '/').to_r
        when :milliseconds
            timestamp = timestamp.to_f / 1000
        when :seconds
            timestamp = timestamp.to_i
        end

        Time.at(timestamp)
    end

    def timestamp(unit = :milliseconds)
        case unit
        when :nanoseconds
            to_r.to_s.gsub(/\//, '_')
        when :milliseconds
            (to_f * 1000).truncate.to_s
        when :seconds
            to_s
        end
    end
end
