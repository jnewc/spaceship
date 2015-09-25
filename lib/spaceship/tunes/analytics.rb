module Spaceship
  module Tunes
    class Analytics < TunesBase

      class << self

        # @return (?) Returns analytics for each of the given apps
        def apps(apps, start_date, end_date)
          measures = [
            "pageViewCount",
            "units",
            "sales",
            "sessions"
          ]
          client.analytics_applist(apps, measures, start_date, end_date)
        end

        # @return (?) Returns a crashes time series for each of the given apps
        def crashes(apps, start_date, end_date)
          measures = ["crashes"]
          client.analytics_time_series(apps, measures, start_date, end_date)
        end

      end

    end
  end
end
