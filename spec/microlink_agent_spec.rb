require 'rails_helper'
require 'huginn_agent/spec_helper'

describe Agents::MicrolinkAgent do
  before(:each) do
    @agent = Agents::MicrolinkAgent.new(:name => "MicrolinkAgent")
    @agent.user = users(:bob)
    @agent.save!
  end

  describe "#receive", :vcr do
    it "gets a result from Microlink" do
      event = Event.new
      event.agent = agents(:bob_rain_notifier_agent)
      event.payload = { "url" => "http://example.com" }
      event.save!

      expect do
        @agent.receive([event])
      end.to change(@agent.events, :count).by(1)
    end
  end
end
