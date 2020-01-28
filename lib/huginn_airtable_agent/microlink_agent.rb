require 'httparty'


module Agents
  class MicrolinkAgent < Agent
    include FormConfigurable

    cannot_be_scheduled!

    description <<-MD
      Add a Agent description here
    MD

    def default_options
      {
        pdf: false,
        screenshot: false,
        merge: false
      }
    end

    form_configurable :pdf, type: :boolean
    form_configurable :screenshot, type: :boolean
    form_configurable :merge, type: :boolean

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

        payload = boolify(options['merge']) ? event.payload : {}
        payload.merge!(result)

        create_event payload: payload
      end
    rescue => e
      error(e.message)
      raise
    end
  end
end
