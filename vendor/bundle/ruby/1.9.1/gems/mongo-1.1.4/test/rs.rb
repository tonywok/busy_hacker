#!/usr/bin/ruby

require 'rubygems'
require 'mongo'

START_PORT = 27017
N = 4

N.times do |n|
  system("sudo rm -rf /data/rs#{n}")
  system("sudo mkdir -p /data/rs#{n}")
  system("sudo chown kyle:kyle /data/rs#{n}")
  system("mongod --replSet replica-set-foo --logpath '#{n}.log' --dbpath /data/rs#{n} --port #{START_PORT + n} --fork")
end

con =<<DOC
  config = {_id: 'replica-set-foo',
    members: [{_id: 0, host:'localhost:27017'},
      {_id:1, host:'localhost:27018'},
      {_id: 2, host: 'localhost:27019', arbiterOnly: true},
      {_id: 3, host: 'localhost:27020'}]}"
DOC

puts con
