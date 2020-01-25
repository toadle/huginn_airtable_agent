module Agents
  class AirtableAgent < Agent
    default_schedule '12h'

    description <<-MD
      Add a Agent description here
    MD

    def default_options
      {
        api_key: "",
        app_key: "",
        table_name: ""
      }
    end

    def validate_options
    end

    def working?
      # Implement me! Maybe one of these next two lines would be a good fit?
      # checked_without_error?
      # received_event_without_error?
    end

#    def check
#    end

    def receive(incoming_events)
      client = Airtable::Client.new(options[:api_key])
      table = client.table(options[:app_key], options[:table_name])

      incoming_events.each do |event|
        record = Airtable::Record.new(event.payload.symbolize_keys)
        table.create(record)
      end
    rescue => e
      error(e.message)
      raise
    end
  end
end
