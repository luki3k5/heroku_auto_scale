require 'spec_helper'

describe HerokuAutoScale::HerokuOperations do
  subject { HerokuAutoScale::HerokuOperations.new("api_key", "app_name") }

  let(:heroku_info_response) do
    {
      "command"    => "bundle exec fake_process_name",
      "created_at" => "2015-04-13T11:36:03Z",
      "id"         => "xxx-xxx-xxx-xxx",
      "type"       => "sidekiq_followers",
      "quantity"   => 1,
      "size"       => "2X",
      "updated_at" => "2015-05-10T17:26:08Z"
    }
  end

  context 'should_scale?' do
    it 'doesn\'t allow to scale for the same no. of dynos' do
      allow(subject).to receive_message_chain(:heroku_connection, :formation, :info).
        and_return(heroku_info_response)
      expect(subject.send(:should_scale?, "process_name", 1)).to eq(false)
    end

    it 'does allow to scale for the greater no. of dynos' do
      allow(subject).to receive_message_chain(:heroku_connection, :formation, :info).
        and_return(heroku_info_response)
      expect(subject.send(:should_scale?, "process_name", 2)).to eq(true)
    end

    it 'does allow to scale for the smaller no. of dynos' do
      allow(subject).to receive_message_chain(:heroku_connection, :formation, :info).
        and_return(heroku_info_response)
      expect(subject.send(:should_scale?, "process_name", 0)).to eq(true)
    end
  end

end
