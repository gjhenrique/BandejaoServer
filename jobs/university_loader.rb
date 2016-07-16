class UniversityLoader
  def self.update_universities_from_file(path)
    old_universities = University.all.to_a
    new_universities = load_from_file(path)
    update_universities(old_universities, new_universities)
  end

  def self.load_from_file(path)
    universities_hash = YAML.load_file path
    universities = universities_hash.map do |name, un_info|
      University.new(name: name,
                     long_name: un_info['long_name'],
                     website: un_info['website'],
                     class_name: un_info['class_name'])
    end
    assign_parent_universities(universities_hash, universities)
    universities
  end

  def self.assign_parent_universities(universities_hash, universities)
    children_hash = universities_hash.select { |_, un| !un['parent'].nil? }
    children_hash.each do |name, child_hash|
      parent_university = universities.find { |un| un.name == child_hash['parent'] }
      child_university = universities.find { |un| un.name == name }
      child_university.university = parent_university
    end
  end

  def self.update_universities(old_universities, new_universities)
    insert_university = new_universities - old_universities
    insert_university.map(&:save)

    delete_university = old_universities - new_universities
    delete_university.map(&:destroy)

    update_existing_universities(old_universities, new_universities)
  end

  def self.update_existing_universities(old_universities, new_universities)
    old_hash = Hash[old_universities.collect { |un| [un, un] }]
    new_universities.each do |un|
      old = old_hash[un]
      next if old.nil?
      if clean_attributes(old) != clean_attributes(un)
        old.attributes = clean_attributes(un)
        old.save
      end

      if un.university != old.university
        old.university = un.university
        old.save
      end
    end
  end

  def self.clean_attributes(un)
    un.attributes.except('id', 'updated_at', 'created_at')
  end
end
