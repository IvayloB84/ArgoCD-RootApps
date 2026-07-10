require 'prometheus/client'
require 'prometheus/middleware/exporter'

# Initialize the global Prometheus registry
prometheus = Prometheus::Client.registry

# Inject the official exporter middleware so K3s can scrape container metrics
Rails.application.config.middleware.use Prometheus::Middleware::Exporter, registry: prometheus