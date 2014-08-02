FactoryGirl.define do
    factory :category do
        name "Factory"
    end

    factory :series do
        name "Factories"
    end

    factory :post do
        author "worker"
        date Date.new(2014, 1, 1)
        title "Hello Factory"
        content "Just saying hello from this factory."
    end

    factory :tagged_post, :parent => :post do
        after :build do |post, evaluator|
            post.categories << FactoryGirl.create(:category)
            post.series = FactoryGirl.create(:series)
        end
    end

    factory :tags, :class => Tag do
        association :category, :factory => :category
        association :post, :factory => :post
    end

    factory :chapter do
        association :series, :factory => :series
        association :post, :factory => :post
    end
end