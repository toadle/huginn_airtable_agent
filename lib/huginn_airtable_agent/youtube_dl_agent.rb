require 'terrapin'

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
        line = Terrapin::CommandLine.new("youtube-dl", "-j", event.payload["url"])
        result = { "youtube-dl": line.run }

        payload = boolify(options['merge']) ? event.payload : {}
        payload.merge!(result)

        create_event payload: payload
      end
    rescue => e
      error(e.message)
      log(event.payload["url"])
      raise
    end
  end
end
