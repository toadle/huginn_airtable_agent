require 'huginn_agent'

#HuginnAgent.load 'huginn_airtable_agent/concerns/my_agent_concern'
HuginnAgent.register 'huginn_airtable_agent/airtable_agent'
HuginnAgent.register 'huginn_airtable_agent/microlink_agent'
HuginnAgent.register 'huginn_airtable_agent/youtube_dl_agent'
