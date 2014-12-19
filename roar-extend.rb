#!/usr/bin/env ruby

require 'roar/json/json_api'
require 'benchmark'

Person = Struct.new(:id, :first_name, :last_name, :age) do
  def to_s
    "#{first_name} #{last_name}, age #{age}"
  end
end

module PersonRepresenter
  include Roar::JSON::JSONAPI
  type :persons

  property :id
  property :first_name
  property :last_name
  property :age

  links do
    property :id, :as => :uid
  end

  link "persons.self" do
    {
      type: "self",
      href: "http://foaf.org/{persons.uid}"
    }
  end
end

tony     = Person.new(0, "Anthony",  "Bargnesi", 32)
kate     = Person.new(1, "Katie",    "Bargnesi", 32)
emma     = Person.new(2, "Emma",     "Bargnesi",  2)
caroline = Person.new(3, "Caroline", "Bargnesi",  1)

SAMPLES  = 5000
Header   = "Create via roar using extend, samples: #{SAMPLES}"
Benchmark.bm(Header.size) do |bm|
  bm.report(Header) {
    tony.extend(PersonRepresenter)
    kate.extend(PersonRepresenter)
    emma.extend(PersonRepresenter)
    caroline.extend(PersonRepresenter)
    SAMPLES.times do
      MultiJson.dump(tony.to_hash)
      MultiJson.dump(kate.to_hash)
      MultiJson.dump(emma.to_hash)
      MultiJson.dump(caroline.to_hash)
    end
  }
end
