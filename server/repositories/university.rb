# frozen_string_literal: true

# container = ROM.container(:sql, ENV['DATABASE_URL']) do |config|
#   config.relation(:universities) do
#     schema(infer: true)
#     auto_struct true
#   end
# end

module Repositories
  class University < ROM::Repository[:universities]
    def by_name(name)
      universities.where(name: name)
    end
  end
end
