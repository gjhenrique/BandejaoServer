# frozen_string_literal: true

class UniversityLoader
  class << self
    def update!(path)
      ActiveRecord::Base.transaction do
        universities_hash = YAML.load_file(path).with_indifferent_access
        update_from_file(universities_hash)
        remove_old_universities(universities_hash)
      end
    end

    private

    def update_from_file(universities_hash)
      universities_hash.each do |name, un_info|
        university = University.find_or_create_by!(name: name)
        parent = University.find_by(name: un_info[:parent])
        info = un_info.merge(university: parent)
        university.update_attributes!(info.except(:parent))
      end
    end

    def remove_old_universities(universities_hash)
      names = universities_hash.keys
      University.where.not(name: names).destroy_all
    end
  end
end
