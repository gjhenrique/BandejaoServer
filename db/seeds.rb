# -*- coding: utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Period.where(name: "BREAKFAST").first_or_create
Period.where(name: "LUNCH").first_or_create
Period.where(name: "DINNER").first_or_create
# Lunch and Dinner
Period.where(name: "BOTH").first_or_create

University.where(name: "UFAC", long_name: "Universidade Federal do Acre", class_name: "Parser::UfacParser").first_or_create
University.where(name: "UEL", long_name: "Universidade Estadual de Londrina", class_name: "Parser::UelParser").first_or_create
