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
    new_universities.each do |new|
      old = old_hash[new]
      next if old.nil?
      if clean_attributes(old) != clean_attributes(new)
        old.attributes = clean_attributes(new)
        old.save
      end

      next if new.university == old.university

      old.university = new.university
      # If the new university does not have a parent anymore
      if new.university.nil?
        university = nil
      else
        # If the new university has a parent now
        university = University.where(name: new.university.name).first
        raise "University #{university.name} has to be persisted first" if university.nil?
      end
      old.update(university: university)
    end
  end

  def self.clean_attributes(un)
    un.attributes.except('id', 'updated_at', 'created_at')
  end
end
