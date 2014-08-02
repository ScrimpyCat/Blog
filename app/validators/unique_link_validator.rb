class UniqueLinkValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
        record.errors.add attribute, "can't have the same link" if record.class.where("replace(lower(#{attribute}), ' ', '-') = replace(lower(:value), ' ', '-')", {
            :value => value
        }).where.not(:id => record.id).first
    end
end