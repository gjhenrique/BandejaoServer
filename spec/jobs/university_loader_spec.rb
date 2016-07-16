require File.expand_path '../../spec_helper.rb', __FILE__
RSpec.describe UniversityLoader do
  let(:yml_file) do
    File.dirname(__FILE__) + '/university_test.yml'
  end

  it 'adds new universities' do
    university = build(:university)
    UniversityLoader.update_universities [], [university]
    expect(University.count).to eq(1)
  end

  it 'does not add duplicated universities' do
    un = create(:university)
    UniversityLoader.update_universities [un], [un]
    expect(University.count).to eq(1)
  end

  it 'saves campus universities' do
    parent_university = build(:university)
    child_university = build(:university, :du)
    child_university.university = parent_university

    UniversityLoader.update_universities [], [parent_university, child_university]
    db_university = University.where(name: child_university.name).first
    expect(db_university.university.name).to eq(parent_university.name)
  end

  it 'adds campus university after it was saved' do
    create(:university)
    create(:university, :du)

    parent_university = build(:university)
    child_university = build(:university, :du)

    child_university.university = parent_university
    UniversityLoader.update_universities University.all.to_a, [parent_university, child_university]

    db_university = University.where(name: child_university.name).first
    expect(db_university.university).not_to be_nil
    expect(db_university.university.name).to eq(parent_university.name)
  end

  it 'removes universities' do
    university = create(:university)
    UniversityLoader.update_universities [university], []
    expect(University.count).to eq(0)
  end

  it 'updates universities info' do
    university = create(:university)
    new_university = build(:university)

    new_university.website = 'A'
    new_university.class_name = 'B'
    new_university.long_name = 'C'

    UniversityLoader.update_universities [university], [new_university]

    expect(University.first.website).to eq('A')
    expect(University.first.class_name).to eq('B')
    expect(University.first.long_name).to eq('C')
  end

  it 'builds universities from seeds file' do
    universities = UniversityLoader.load_from_file yml_file
    expect(universities.size).to eq(2)
    expect(universities.first.website).to eq('C')
    expect(universities.first.class_name).to eq('B')
    expect(universities.first.long_name).to eq('A')
  end

  it 'builds universities with campus from seeds file' do
    universities = UniversityLoader.load_from_file yml_file
    expect(universities.second.university).to eq(universities.first)
  end
end
