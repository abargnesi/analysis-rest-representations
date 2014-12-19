#!/usr/bin/env ruby

require 'multi_json'
require 'yaks'
require 'benchmark'

Person = Struct.new(:id, :first_name, :last_name, :age) do
  def to_s
    "#{first_name} #{last_name}, age #{age}"
  end
end

class PersonMapper < Yaks::Mapper
  link :self, "http://foaf.org/{id}"

  attributes :id, :first_name, :last_name, :age
end

tony     = Person.new(0, "Anthony",  "Bargnesi", 32)
kate     = Person.new(1, "Katie",    "Bargnesi", 32)
emma     = Person.new(2, "Emma",     "Bargnesi",  2)
caroline = Person.new(3, "Caroline", "Bargnesi",  1)

yaks = Yaks.new do
  default_format :json_api
  json_serializer do |data|
    MultiJson.dump(data)
  end
end

SAMPLES  = 5000
Header   = "Create via Yaks mappers, samples: #{SAMPLES}"
Benchmark.bm(Header.size) do |bm|
  bm.report(Header) {
    SAMPLES.times do
      yaks.call(tony,     :mapper => PersonMapper)
      yaks.call(kate,     :mapper => PersonMapper)
      yaks.call(emma,     :mapper => PersonMapper)
      yaks.call(caroline, :mapper => PersonMapper)
    end
  }
end
