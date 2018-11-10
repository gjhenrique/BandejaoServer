# frozen_string_literal: true

describe UniversityRepresenter do
  it 'renders a single element correctly' do
    un = build_stubbed(:university)
    representer = described_class.represent(un)
    object = JSON.parse(representer.to_json, symbolize_names: true)

    expect(object[:name]).to eq un.name
    expect(object[:website]).to eq un.website
    expect(object[:long_name]).to eq un.long_name
  end

  it 'renders a list correctly' do
    universities = build_stubbed_list(:university, 3)
    representer = described_class.represent(universities)
    list = JSON.parse(representer.to_json, symbolize_names: true)

    expect(list.count).to eq 3
  end
end
