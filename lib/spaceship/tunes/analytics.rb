module Spaceship
  module Tunes
    class Analytics < TunesBase

      class << self

        # App Analytics

        # @return (?) Returns analytics for each of the given apps
        def apps(apps, start_date, end_date)
          measures = ["pageViewCount", "units", "sales", "sessions"]
          client.analytics_applist(apps, measures, start_date, end_date)
        end

        # @return (?) Returns a crashes time series for each of the given apps
        def crashes(apps, start_date, end_date)
          measures = ["crashes"]
          client.analytics_time_series(apps, measures, start_date, end_date)
        end

        # @return (?) Returns all-time stats for the given app
        def all_time(app_id)
          measures = ["pageViewCount", "units", "sales", "sessions", "crashes"]
          #["pageViewCount", "units", "iap", "sales", "activeDevices", "sessions", "payingUsers", "crashes"]
          client.analytics_all_time([app_id], measures)
        end

        # App Store Reviews

        def reviews(app_id, country_code)
          client.all_reviews(app_id, country_code)
        end

      end

    end
  end
end
