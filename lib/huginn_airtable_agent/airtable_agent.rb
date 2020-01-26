module Agents
  class AirtableAgent < Agent
    cannot_be_scheduled!
    cannot_create_events!

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
      errors.add(:base, "you need to specify the API-Key for your Airtable-Account") unless options['api_key'].present?
      errors.add(:base, "you need to specify the App-Key for the Workspace which contains your table") unless options['app_key'].present?
      errors.add(:base, "you need to specify the Table-Name") unless options['table_name'].present?
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
