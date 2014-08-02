require 'rails_helper'

describe PostController do
    let(:day_after_last_post){ Date.new(2014, 1, 1) }
    before {
        category = FactoryGirl.create(:category)
        series = FactoryGirl.create(:series)
        1.upto(PostController::BATCH_MAX + 1) { |i| FactoryGirl.create(:post, :title => nil, :date => day_after_last_post.prev_day(i), :categories => [category], :series => series) }
    }

    let(:last_from_batch_id){ "post-#{Post.limit(PostController::BATCH_MAX).last.date.to_time.timestamp}" }
    let(:before_all_posts_id){ "post-#{day_after_last_post.to_time.timestamp}" }

    describe 'GET #view_all' do
        before { get :view_all }

        it { expect(response).to be_success }
        it { expect(response).to have_http_status(200) }
        it { expect(response).to render_template(:view_all) }

        describe 'request more posts' do
            before { xhr :get, :view_all, :last_post_id => last_from_batch_id }

            it { expect(response).to be_success }
            it { expect(response).to have_http_status(200) }
            it { expect(response).to render_template(:_posts) }
            it { expect(JSON.parse(response.body)['finished']).to be_truthy }
        end

        describe 'request first posts' do
            before { xhr :get, :view_all, :last_post_id => before_all_posts_id }

            it { expect(response).to be_success }
            it { expect(response).to have_http_status(200) }
            it { expect(response).to render_template(:_posts) }
            it { expect(JSON.parse(response.body)['finished']).to be_falsey }
        end
    end

    describe 'GET #view_series' do
        before { get :view_series }

        it { expect(response).to be_success }
        it { expect(response).to have_http_status(200) }
        it { expect(response).to render_template(:view_series) }

        describe 'request more posts' do
            before { xhr :get, :view_series, :series => FactoryGirl.attributes_for(:series)[:name], :last_post_id => last_from_batch_id }

            it { expect(response).to be_success }
            it { expect(response).to have_http_status(200) }
            it { expect(response).to render_template(:_posts) }
            it { expect(JSON.parse(response.body)['finished']).to be_truthy }
        end

        describe 'request first posts' do
            before { xhr :get, :view_series, :series => FactoryGirl.attributes_for(:series)[:name], :last_post_id => before_all_posts_id }

            it { expect(response).to be_success }
            it { expect(response).to have_http_status(200) }
            it { expect(response).to render_template(:_posts) }
            it { expect(JSON.parse(response.body)['finished']).to be_falsey }
        end
    end

    describe 'GET #view_category' do
        before { get :view_category }

        it { expect(response).to be_success }
        it { expect(response).to have_http_status(200) }
        it { expect(response).to render_template(:view_category) }

        describe 'request more posts' do
            before { xhr :get, :view_category, :tags => FactoryGirl.attributes_for(:category)[:name], :last_post_id => last_from_batch_id }

            it { expect(response).to be_success }
            it { expect(response).to have_http_status(200) }
            it { expect(response).to render_template(:_posts) }
            it { expect(JSON.parse(response.body)['finished']).to be_truthy }
        end

        describe 'request first posts' do
            before { xhr :get, :view_category, :tags => FactoryGirl.attributes_for(:category)[:name], :last_post_id => before_all_posts_id }

            it { expect(response).to be_success }
            it { expect(response).to have_http_status(200) }
            it { expect(response).to render_template(:_posts) }
            it { expect(JSON.parse(response.body)['finished']).to be_falsey }
        end
    end

    describe 'GET #view_single' do
        describe 'post from id' do
            before { get :view_single, :id => 1 }

            it { expect(response).to be_success }
            it { expect(response).to have_http_status(200) }
            it { expect(response).to render_template(:view_single) }
        end

        describe 'post from title' do
            before {
                FactoryGirl.create(:post)
                get :view_single, :title => FactoryGirl.attributes_for(:post)[:title]
            }

            it { expect(response).to be_success }
            it { expect(response).to have_http_status(200) }
            it { expect(response).to render_template(:view_single) }
        end
    end
end
