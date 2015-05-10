# HerokuAutoScale

Idea of this gem is to allow for simple and queue system agnostic
scalability of background jobs on heroku.

Imagine having multimple queues of some kind, each time there are no
jobs these queues are just hanging there - wasting their time staying online. 
On the other hand when there is a spike in number of scheduled jobs it would be
good to increase the number of dynos to process them faster.

This gem provides simple DSL for doing just that.
It allows to set a meaningful constrains for your dynos such as
minimum/maximum number of dynos and scaling step.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'heroku_auto_scale'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install heroku_auto_scale

In case of rails applications you may want to create new initializer
with the following content:

```ruby

include HerokuAutoScale

HerokuAutoScale.configure do |c|
  c.redis_url          = ENV['REDISCLOUD_URL']
  c.heroku_oauth_token = ENV['HEROKU_TOKEN']
  c.heroku_app_name    = ENV['APP_NAME']
end


```

Make sure that you have corresponding environment variables setup.

## Usage

Below is simple example how to use this gem:

```ruby

heroku_observe do
  queue_name   "queue:followers_jobs"
  process_name "sidekiq_followers"

  max_dynos 2
  min_dynos 1
  scaling_step 2000
end

```

The meaning of options is:
- queue_name - the name of the queue in redis that you wish to observe
- process_name - name of the heroku process to scale
- max_dynos - maximum number of dynos you want to scale up to 
- min_dynos - minimum number of dynos you want to scale down to
- scaling_step - number of jobs it take to scale your dynos

For adding timely checks I recommend using great [clockwork](https://github.com/adamwiggins/clockwork)

## Contributing

1. Fork it ( https://github.com/[my-github-username]/heroku_auto_scale/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
