require 'rails_helper'
require 'huginn_agent/spec_helper'

describe Agents::AirtableAgent do
  before(:each) do
    @valid_options = {
      api_key: "123",
      app_key: "abc",
      table_name: "a table name"
    }
    @agent = Agents::AirtableAgent.new(:name => "AirtableAgent", :options => @valid_options)
    @agent.user = users(:bob)
    @agent.save!
  end

  describe "#validate_options" do
    before do
      expect(@agent).to be_valid
    end

    it "should require the Airtable Api-Key" do
      @agent.options['api_key'] = nil
      expect(@agent).not_to be_valid
    end

    it "should require the Airtable App-Key" do
      @agent.options['app_key'] = nil
      expect(@agent).not_to be_valid
    end

    it "should require the Airtable Table-Name" do
      @agent.options['table_name'] = nil
      expect(@agent).not_to be_valid
    end
  end

  describe "#receive", :vcr do
    it "saves payload to Airtable-Table" do
      event = Event.new
      event.agent = agents(:bob_rain_notifier_agent)
      event.payload = { "Title" => "This is another title", "URL" => "http://example.com" }
      event.save!

      Agents::AirtableAgent.async_receive(@agent.id, [event.id])
    end
  end
end
