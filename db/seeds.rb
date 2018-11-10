# frozen_string_literal: true

Period.where(name: 'BREAKFAST').first_or_create
Period.where(name: 'LUNCH').first_or_create
Period.where(name: 'VEGETARIAN LUNCH').first_or_create
Period.where(name: 'DINNER').first_or_create
Period.where(name: 'VEGETARIAN DINNER').first_or_create
Period.where(name: 'BOTH').first_or_create

seeds_file = File.join(settings.root, 'config', 'universities.yml')
UniversityLoader.update!(seeds_file)
