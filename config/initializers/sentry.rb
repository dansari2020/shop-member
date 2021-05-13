Sentry.init do |config|
  config.dsn = 'https://556bc20e1aa0414a993cb5cfd5a101b6@o659034.ingest.sentry.io/5763869'
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  # Set tracesSampleRate to 1.0 to capture 100%
  # of transactions for performance monitoring.
  # We recommend adjusting this value in production
  config.traces_sample_rate = 0.5
  # or
  config.traces_sampler = lambda do |context|
    true
  end
end