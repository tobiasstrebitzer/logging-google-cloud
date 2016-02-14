require "gcloud"

module Logging
  module Appenders

    def self.gcl( *args )
      if !Gcloud.instance_methods.include?(:logging)
        puts "-- Gcloud Logging module not available. Please use the latest gcloud version from github master."
        return false
      end
      return ::Logging::Appenders::GoogleCloudLogging if args.empty?
      ::Logging::Appenders::GoogleCloudLogging.new(*args)
    end

    class GoogleCloudLogging < ::Logging::Appender
      SEVERITY_NAMES = %w(DEBUG INFO NOTICE WARNING ERROR CRITICAL ALERT EMERGENCY)
      
      include Buffering
      attr_reader :project_id, :log_name, :resource_type, :resource_labels, :keyfile

      def initialize(name, options={})
        super(name, options)
        auto_flushing = options.fetch(:buffsize, options.fetch(:buffer_size, 100))
        configure_buffering({:auto_flushing => auto_flushing}.merge(options))

        @project_id = options.fetch(:project_id, nil)
        raise ArgumentError, 'Must specify project id' if @project_id.nil?

        @log_name = options.fetch(:log_name, nil)
        raise ArgumentError, 'Must specify log name' if @log_name.nil?
        
        @resource_type = options.fetch(:resource_type, nil)
        raise ArgumentError, 'Must specify resource type' if @resource_type.empty?
        
        @resource_labels = options.fetch(:resource_labels, nil)
        @keyfile = options.fetch(:keyfile, nil)
      end
      
      def gcloud_logging
        @gcloud_logging ||= Gcloud.new(@project_id, @keyfile).logging
      end
      
      def resource
        gcloud_loggging.resource(@resource_type, @resource_labels)
      end

      def close( *args )
        super(false)
      end
      
      def flush
        return self if @buffer.empty?
        entries = nil
        sync do
          entries = @buffer.dup
          @buffer.clear
        end

        send_entries(entries)

        self
      end

    private

      def write(event)
        entry = gcloud_logging.entry.tap do |entry|
          entry.timestamp = Time.now
          entry.severity = ::Logging::LNAMES[event.level]
          entry.payload = event.data
          entry.labels[:file] = event.file if !event.file.empty?
          entry.labels[:line] = event.line if !event.line.empty?
          entry.labels[:method] = event.method if !event.method.empty?
        end

        if @auto_flushing == 1
          send_entries([entry])
        else
          sync {
            @buffer << entry
          }
          @periodic_flusher.signal if @periodic_flusher
          flush if @buffer.length >= @auto_flushing || immediate?(event)
        end

        self
      end
      
      def send_entries(entries)
        gcloud_logging.write_entries(entries, log_name: @log_name, resource: resource)
      end

    end
  end
end
