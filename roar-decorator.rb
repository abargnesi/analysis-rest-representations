#!/usr/bin/env ruby

require 'multi_json'

require 'roar/decorator'
require 'roar/json/json_api'
require 'benchmark'

Person = Struct.new(:id, :first_name, :last_name, :age) do
  def to_s
    "#{first_name} #{last_name}, age #{age}"
  end
end

class PersonDecorator < Roar::Decorator
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
Header   = "Create via roar decorators, samples: #{SAMPLES}"
Benchmark.bm(Header.size) do |bm|
  bm.report(Header) {
    SAMPLES.times do
      MultiJson.dump(PersonDecorator.new(tony).to_hash)
      MultiJson.dump(PersonDecorator.new(kate).to_hash)
      MultiJson.dump(PersonDecorator.new(emma).to_hash)
      MultiJson.dump(PersonDecorator.new(caroline).to_hash)
    end
  }
end
