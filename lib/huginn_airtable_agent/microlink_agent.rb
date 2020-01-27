require 'httparty'


module Agents
  class MicrolinkAgent < Agent
    cannot_be_scheduled!

    description <<-MD
      Add a Agent description here
    MD

    def default_options
      {
        pdf: false,
        screenshot: false
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
        response = HTTParty.get("https://api.microlink.io?pdf=#{options['pdf']}&screenshot=#{options['screenshot']}&url=" + event.payload["url"])
        result = JSON.parse response.body

        create_event payload: event.payload.merge(result)
      end
    rescue => e
      error(e.message)
      raise
    end
  end
end
