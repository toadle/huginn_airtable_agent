require 'open3'
require 'json'

module Agents
  class YoutubeDlAgent < Agent
    cannot_be_scheduled!

    description <<-MD
      Add a Agent description here
    MD

    def default_options
      {
        merge: false
      }
    end

    def validate_options
    end

    def working?
      checked_without_error?
      received_event_without_error?
    end

    def receive(incoming_events)
      incoming_events.each do |event|
        result = Open3.capture2("youtube-dl", "-j", event.payload["url"])
        if result[0]
          begin
            payload = boolify(options['merge']) ? event.payload : {}
            payload.merge!(JSON.parse result[0])
            create_event payload: payload
          rescue => ex
            error(ex.message)
            log(result)
          end
        end
      end
    rescue => e
      error(e.message)
      raise
    end
  end
end
