# require 'sidekiq-scheduler'

# require_relative 'job_presenter'

require 'sidekiq-scheduler-manager'

module SidekiqSchedulerManager
  module Web
    VIEW_PATH = File.expand_path('../../../web/views', __FILE__)

    def self.registered(app)
      app.get '/schedulers' do
        @schedulers = Sidekiq.get_all_schedules

        # erb File.read(File.join(VIEW_PATH, 'index.html.erb'))
        erb File.read(File.join(VIEW_PATH, 'scheduler.html.erb'))
      end

      app.get '/scheduler/:id' do
        @scheduler = Sidekiq.get_schedule(params[:id])
        erb File.read(File.join(VIEW_PATH, 'scheduler_edit.html.erb'))
      end

      app.put '/scheduler/:id' do
        @scheduler = Sidekiq.get_schedule(params[:id])

        # Sidekiq.set_schedule(@scheduler['class'], { :class => @scheduler['class'],
        #                                             :every => '["1d", {"first_in"=>"1s"}]',
        #                                             :queue => @scheduler['class'],
        #                                             :description => 'test'})

        # @params = params[:scheduler]
        Sidekiq.set_schedule(params[:id], params[:scheduler])
        redirect('/sidekiq/schedulers')
      end

      app.get '/schedulers/new' do
        erb File.read(File.join(VIEW_PATH, 'scheduler_new.html.erb'))
      end

      app.post '/schedulers' do
        job_name = params[:scheduler]['job_name']
        Sidekiq.set_schedule(job_name, params[:scheduler])
        redirect('/sidekiq/schedulers')
      end

      app.delete '/scheduler/:id' do
        # Sidekiq.set_schedule(params[:id], { noop: nil })
        schedules = Sidekiq.get_all_schedules.reject { |k, v| k == params[:id] }
        Sidekiq.schedule = schedules
        redirect('/sidekiq/schedulers')
      end

      app.get '/scheduler/:id/reject' do
        schedules = Sidekiq.get_all_schedules.reject { |k, v| k == '' }
        Sidekiq.schedule = schedules
        # Sidekiq.set_schedule(params[:id], { noop: nil })
        schedules = Sidekiq.get_all_schedules.reject { |k, v| k == params[:id] }
        Sidekiq.schedule = schedules
        redirect('/sidekiq/schedulers')
      end

    end
  end
end

require 'sidekiq/web' unless defined?(Sidekiq::Web)
Sidekiq::Web.register(SidekiqSchedulerManager::Web)
Sidekiq::Web.tabs['scheduler manager'] = 'schedulers'
Sidekiq::Web.locales << File.expand_path(File.dirname(__FILE__) + "/../../web/locales")
