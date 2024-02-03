#!/bin/sh


#Set variable: SECRET_KEY_BASE=

export SECRET_KEY_BASE=$(rails secret)
export RAILS_ENV=production rails assets:precompile
