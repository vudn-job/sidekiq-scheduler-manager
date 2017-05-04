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
        job_name = params[:id]

        unless job_name.to_s.strip.empty?
          @scheduler = Sidekiq.get_schedule(params[:id])
          data = {
              :class => params[:scheduler]['class'],
              :queue => params[:scheduler]['queue'],
              :description => params[:scheduler]['description'],
              :args => params[:scheduler]['args'],
          }

          if not params[:scheduler]['cron'].to_s.strip.empty?
            data[:cron] = params[:scheduler]['cron']
          elsif not params[:scheduler]['every'].to_s.strip.empty?
            data[:every] = params[:scheduler]['every']
          end

          Sidekiq.set_schedule(job_name, data)
        end

        redirect(root_path + '/schedulers')

      end

      app.get '/schedulers/new' do
        erb File.read(File.join(VIEW_PATH, 'scheduler_new.html.erb'))
      end

      app.post '/schedulers' do
        job_name = params[:scheduler]['name']

        unless job_name.to_s.strip.empty?
          data = {
              :class => params[:scheduler]['class'],
              :queue => params[:scheduler]['queue'],
              :description => params[:scheduler]['description'],
              :args => params[:scheduler]['args'],
          }

          if not params[:scheduler]['cron'].to_s.strip.empty?
            data[:cron] = params[:scheduler]['cron']
          elsif not params[:scheduler]['every'].to_s.strip.empty?
            data[:every] = params[:scheduler]['every']
          end

          Sidekiq.set_schedule(job_name, data)
        end

        redirect('/sidekiq/schedulers')
      end

      app.delete '/scheduler/:id' do
        # Sidekiq.set_schedule(params[:id], { noop: nil })
        schedules = Sidekiq.get_all_schedules.reject { |k, v| k == params[:id] }
        Sidekiq.schedule = schedules
        redirect('/sidekiq/schedulers')
      end

      app.get '/scheduler/:id/reject' do
        # Sidekiq.set_schedule(params[:id], { noop: nil })
        # schedules = Sidekiq.get_all_schedules.reject { |k, v| k == params[:id] }
        # Sidekiq.schedule = schedules

        Sidekiq.remove_schedule(params[:id])
        redirect('/sidekiq/schedulers')
      end

    end
  end
end

require 'sidekiq/web' unless defined?(Sidekiq::Web)
Sidekiq::Web.register(SidekiqSchedulerManager::Web)
Sidekiq::Web.tabs['scheduler manager'] = 'schedulers'
Sidekiq::Web.locales << File.expand_path(File.dirname(__FILE__) + "/../../web/locales")
