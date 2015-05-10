require 'spec_helper'

describe HerokuAutoScale::Configuration do
  subject do
    Object.new.extend(HerokuAutoScale::Configuration)
  end

  it 'allows to set allowed attributes' do
    subject.configure do |c|
      c.redis_url = 'url'
      c.heroku_oauth_token = 'token'
      c.heroku_app_name = 'app'
    end

    expect(subject.redis_url).to          eq('url')
    expect(subject.heroku_oauth_token).to eq('token')
    expect(subject.heroku_app_name).to    eq('app')
  end

  it 'retuns hash of it\'s attributes' do
    subject.configure do |c|
      c.redis_url = 'url'
      c.heroku_oauth_token = 'token'
      c.heroku_app_name = 'app'
    end

    expect(subject.options).to eq({
      :redis_url=>"url",
      :heroku_oauth_token=>"token",
      :heroku_app_name=>"app"
    })
  end

end
