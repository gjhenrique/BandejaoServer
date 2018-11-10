# frozen_string_literal: true

describe UniversityLoader do
  def load_fixture(name)
    "#{File.dirname(__FILE__)}/../fixtures/#{name}.yml"
  end

  let(:fixture1) { load_fixture 'test1' }
  let(:fixture2) { load_fixture 'test2' }

  it 'builds universities from seeds file' do
    described_class.update! fixture1
    first = University.first
    second = University.second

    expect(University.count).to eq(2)
    expect(first.website).to eq('C')
    expect(first.class_name).to eq('B')
    expect(first.long_name).to eq('A')
    expect(second.university).to eq first
  end

  it 'does not duplicate universities' do
    described_class.update!(fixture1)
    described_class.update!(fixture1)

    expect(University.count).to eq(2)
  end

  it 'removes universities' do
    name = 'lol'
    create(:university, name: name)

    expect(University.find_by(name: name)).not_to be_nil

    described_class.update!(fixture1)

    expect(University.find_by(name: name)).to be_nil
  end

  it 'updates attributes correctly' do
    described_class.update! fixture1
    described_class.update! fixture2

    first = University.find_by(name: 'PU')
    second = University.find_by(name: 'DU')
    expect(first.long_name).to eq 'F'
    expect(first.class_name).to eq 'D'

    expect(second.university.name).to eq 'XU'
  end
end
