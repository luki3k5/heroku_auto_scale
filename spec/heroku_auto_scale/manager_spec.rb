require 'spec_helper'

describe HerokuAutoScale::Manager do
  let(:redis_test_url_for_test)     { "redis://localhost" }
  let(:heroku_oauth_token_for_test) { "token" }
  let(:heroku_app_name_for_test)    { "app" }
  let(:config_values) do
    [
      redis_test_url_for_test,
      heroku_oauth_token_for_test,
      heroku_app_name_for_test
    ]
  end

  before do
    @keys = HerokuAutoScale::Configuration::CONFIGURATION_OPTIONS
  end

  context 'configuration' do
    before(:each) do
      HerokuAutoScale.configure do |c|
        c.redis_url          = redis_test_url_for_test
        c.heroku_oauth_token = heroku_oauth_token_for_test
        c.heroku_app_name    = heroku_app_name_for_test
      end
    end

    it 'should inherit the config' do
      manager = HerokuAutoScale::Manager.new
      @keys.each do |key|
        expect(
          config_values.include?(manager.send(key))
        ).to eq(true)
      end
    end
  end

  context 'accepting attributes' do
    let(:manager) { HerokuAutoScale::Manager.new }

    it '#set_process_name' do
      manager.set_process_name("some_process_name")
      expect(manager.process_name).to eq("some_process_name")
    end

    it '#set_queue_name' do
      manager.set_queue_name("some_queue_name")
      expect(manager.queue_name).to eq("some_queue_name")
    end

    it '#set_min_dynos' do
      manager.set_min_dynos(1)
      expect(manager.min_dynos).to eq(1)
    end

    it '#set_max_dynos' do
      manager.set_max_dynos(2)
      expect(manager.max_dynos).to eq(2)
    end

    it '#set_scaling_step' do
      manager.set_scaling_step(12000)
      expect(manager.scaling_step).to eq(12000)
    end

  end

  describe 'dynos numbers for scalability' do
    let(:manager) { HerokuAutoScale::Manager.new }

    it 'sets 0 dynos when there are no jobs and min_dynos(0)' do
      manager.set_scaling_step(10_000)
      manager.set_min_dynos(0)
      manager.set_max_dynos(10)
      allow(manager).to receive(:get_number_of_jobs_inside_queue) { 0 }

      expect(manager.calculate_number_of_needed_dynos).to eq(0)
    end

    it 'sets to min dynos when there are no jobs and min_dynos(1)' do
      manager.set_scaling_step(10_000)
      manager.set_min_dynos(1)
      manager.set_max_dynos(10)
      allow(manager).to receive(:get_number_of_jobs_inside_queue) { 0 }

      expect(manager.calculate_number_of_needed_dynos).to eq(1)
    end

    it 'sets 1 dynos when there are jobs till the first scaling_step' do
      manager.set_scaling_step(10_000)
      manager.set_min_dynos(0)
      manager.set_max_dynos(10)
      allow(manager).to receive(:get_number_of_jobs_inside_queue) { 8_000 }

      expect(manager.calculate_number_of_needed_dynos).to eq(1)
    end

    it 'sets 2 dynos when there are jobs till the second scaling_step' do
      manager.set_scaling_step(10_000)
      manager.set_min_dynos(0)
      manager.set_max_dynos(10)
      allow(manager).to receive(:get_number_of_jobs_inside_queue) { 18_000 }

      expect(manager.calculate_number_of_needed_dynos).to eq(2)
    end

    it 'sets max allowed dynos when there are jobs that exceed max_dynos x scaling_step' do
      manager.set_scaling_step(10_000)
      manager.set_min_dynos(0)
      manager.set_max_dynos(4)
      allow(manager).to receive(:get_number_of_jobs_inside_queue) { 180_000 }

      expect(manager.calculate_number_of_needed_dynos).to eq(4)
    end

  end
end
