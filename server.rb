#!/usr/bin/env ruby

require 'sinatra'
require 'mcollective'
require 'json'

include MCollective::RPC

MCO_CONFIG = ENV['MCO_CONFIG'].defined? ? ENV['MCO_CONFIG'] : '/etc/mcollective/client.cfg'

post '/:agent/:action/*' do
  client = rpcclient(params[:agent], :configfile  => MCO_CONFIG)
  client.discover

  content = request.body.read
  data = (content.nil? or content.empty?) ? {} : JSON.parse(content, :symbolize_names => true)

  parse_timeouts(client, data)
  parse_filters(client, data)
  parse_limits(client, data)

  arguments = {}
  if data[:arguments]
    data[:arguments].each do |arg|
      arguments[$1.to_sym] = $2 if arg =~ /^(.+?)=(.+?)$/
    end
  end

  JSON.dump(client.send(params[:action], arguments).map{|r| r.results})
end

def parse_filters(mco, args)
  if args[:filters]
    args[:filters].each do |type, values|
      case type
      when :class
        values.each do |value|
          mco.class_filter "/#{value}/"
        end
      when :fact
        values.each do |value|
          mco.fact_filter "#{value}"
        end
      when :agent
        values.each do |value|
          mco.agent_filter "#{value}"
        end
      when :identity
        values.each do |value|
          mco.identity_filter "#{value}"
        end
      when :compound
        mco.compound_filter "#{values}"
      end
    end
  end
end

def parse_limits(mco, args)
  if args[:limit]
    limits = args[:limit]

    if limits[:targets]
      mco.limit_targets = "#{limits[:targets]}"
    end

    if limits[:method]
      mco.limit_method = "#{limits[:method]}"
    end
  end
end

def parse_timeouts(mco, args)
  if args[:timeout]
    mco.timeout = args[:timeout]
  end

  if args[:discovery_timeout]
    mco.discovery_timeout = args[:discovery_timeout]
  end
end