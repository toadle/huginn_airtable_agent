require 'rails_helper'
require 'huginn_agent/spec_helper'

describe Agents::AirtableAgent do
  before(:each) do
    @valid_options = Agents::AirtableAgent.new.default_options
    @checker = Agents::AirtableAgent.new(:name => "AirtableAgent", :options => @valid_options)
    @checker.user = users(:bob)
    @checker.save!
  end

  pending "add specs here"
end
