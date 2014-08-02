require 'rails_helper'

describe 'Blog' do
    subject { page }
    let(:post_container) { '#posts' }
    let(:post_item) { '#posts article[id^="post-"]' }

    describe 'main page' do
        before { visit blog_url }

        describe 'navigation bar' do
            it { is_expected.to have_link 'About', :href => blog_about_path }
            it { is_expected.to_not have_link 'Blog', :href => blog_path }
            it { is_expected.to have_link 'Category', :href => blog_category_path }
        end

        describe 'posts' do
            context 'empty' do
                it { is_expected.to have_selector post_container }
                specify { expect(all(post_item).count).to eql(0) }
            end

            context 'not empty' do
                before {
                    FactoryGirl.create(:post)
                    visit blog_url
                }

                specify { expect(all(post_item).count).to eql(1) }
            end
        end
    end

    describe 'category page' do
        before { visit blog_category_url }

        describe 'navigation bar' do
            it { is_expected.to have_link 'About', :href => blog_about_path }
            it { is_expected.to have_link 'Blog', :href => blog_path }
            it { is_expected.to_not have_link 'Category', :href => blog_category_path }
        end

        describe 'posts' do
            it { is_expected.to have_selector post_container }
        end

        describe 'categories' do
            let(:tag_container) { '#tags' }
            let(:tag_item){ "#{tag_container} input[type=\"checkbox\"]" }

            context 'empty' do
                it { is_expected.to have_selector tag_container }
                specify { expect(all(tag_item).count).to eql(0) }
            end

            context 'not empty' do
                before {
                    FactoryGirl.create(:tagged_post)
                    visit blog_category_url
                }

                specify { expect(all(tag_item).count).to eql(1) }
                specify('should have name') { expect(find("#{tag_item}[name=\"#{FactoryGirl.attributes_for(:category)[:name].capitalize}\"]")).to_not be_nil }

                describe 'link to selected category' do
                    specify('should include posts') {
                        visit blog_category_url(FactoryGirl.attributes_for(:category)[:name].capitalize)
                        expect(all(post_item).count).to eql(1)
                    }
                end
            end
        end
    end

    describe 'series page' do
        before { visit blog_series_url }

        describe 'navigation bar' do
            it { is_expected.to have_link 'About', :href => blog_about_path }
            it { is_expected.to have_link 'Blog', :href => blog_path }
            it { is_expected.to have_link 'Category', :href => blog_category_path }
        end

        describe 'series' do
            let(:series_container) { '#series' }
            let(:series_item) { "#{series_container} a" }

            it { is_expected.to have_selector series_container }

            context 'empty' do
                specify { expect(all(series_item).count).to eql(0) }
            end

            context 'not empty' do
                before {
                    FactoryGirl.create(:tagged_post)
                    visit blog_series_url
                }

                specify { expect(all(series_item).count).to eql(1) }
                specify {
                    series_name = FactoryGirl.attributes_for(:series)[:name]
                    expect(find(series_container)).to have_link series_name, :href => blog_series_path(series_name)
                }

                describe 'selected' do
                    before { visit blog_series_url(FactoryGirl.attributes_for(:series)[:name]) }

                    specify('should include posts') { expect(all(post_item).count).to eql(1) }
                end
            end
        end
    end

    describe 'post page' do
        let(:post_item_header) { '#posts article[id^="post-"] header' }
        let(:post_item_header_left_side) { "#{post_item_header} div.left-sided" }
        let(:post_item_header_right_side) { "#{post_item_header} div.right-sided" }
        let(:post_item_header_left_side_items) { "#{post_item_header_left_side} > *" }
        let(:post_item_header_right_side_items) { "#{post_item_header_right_side} > *" }

        describe 'default structure' do
            before {
                post = FactoryGirl.create(:post)
                visit blog_post_url(post.title.gsub(/ /, '-'))
            }

            describe 'navigation bar' do
                it { is_expected.to have_link 'About', :href => blog_about_path }
                it { is_expected.to have_link 'Blog', :href => blog_path }
                it { is_expected.to have_link 'Category', :href => blog_category_path }
            end

            it { is_expected.to have_selector post_container }
            it { is_expected.to have_selector post_item }
            it { is_expected.to have_selector post_item_header }
            it { is_expected.to have_selector post_item_header_left_side }
            it { is_expected.to have_selector post_item_header_right_side }
        end

        context 'complete info' do
            before {
                post = FactoryGirl.create(:tagged_post)
                visit blog_post_url(post.title.gsub(/ /, '-'))
            }

            specify { expect(all(post_item_header_left_side_items).count + all(post_item_header_right_side_items).count).to eql(3) }
        end

        context 'incomplete info' do
            before {
                post = FactoryGirl.create(:post, :author => nil, :date => nil)
                visit blog_post_url(post.title.gsub(/ /, '-'))
            }

            specify { expect(all(post_item_header_left_side_items).count + all(post_item_header_right_side_items).count).to eql(0) }
        end
    end

    describe 'about page' do
        before { visit blog_about_url }

        describe 'navigation bar' do
            it { is_expected.to_not have_link 'About', :href => blog_about_path }
            it { is_expected.to have_link 'Blog', :href => blog_path }
            it { is_expected.to_not have_link 'Category', :href => blog_category_path }
        end
    end
end
