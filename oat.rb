#!/usr/bin/env ruby

require 'multi_json'
require 'oat'
require 'oat/adapters/json_api'
require 'benchmark'

Person = Struct.new(:id, :first_name, :last_name, :age) do
  def to_s
    "#{first_name} #{last_name}, age #{age}"
  end
end

class PersonSerializer < Oat::Serializer
  adapter Oat::Adapters::JsonAPI

  schema do
    type :person
    link "self", {:id => item.id, :type => :person, :href => url}

    property :id,         item.id
    property :first_name, item.first_name
    property :last_name,  item.last_name
    property :age,        item.age
  end

  protected

  def url
    "http://foaf.org/#{item.id}"
  end
end

tony     = Person.new(0, "Anthony",  "Bargnesi", 32)
kate     = Person.new(1, "Katie",    "Bargnesi", 32)
emma     = Person.new(2, "Emma",     "Bargnesi",  2)
caroline = Person.new(3, "Caroline", "Bargnesi",  1)

SAMPLES = 5000
Header  = "Create via Oat JSON API serializers, samples: #{SAMPLES}"
Benchmark.bm(Header.size) do |bm|
  bm.report(Header) {
    SAMPLES.times do
      MultiJson.dump(PersonSerializer.new(tony).to_hash)
      MultiJson.dump(PersonSerializer.new(kate).to_hash)
      MultiJson.dump(PersonSerializer.new(emma).to_hash)
      MultiJson.dump(PersonSerializer.new(caroline).to_hash)
    end
  }
end
