# -*- coding: utf-8 -*-
require File.expand_path '../../spec_helper.rb', __FILE__

RSpec.feature 'Homepage', type: :feature do

  before(:each) do
    create(:university)
    create(:university, :du)

    create(:meal, :monday, :one_dish)
    create(:meal, :monday_dinner, :one_dish, :one_dish)
    create(:meal, :this_saturday, :meals_with_fake_dishes)
  end

  scenario 'User can see all universities' do
    visit '/'

    universities = all('#universities li').map(&:text)

    expect(universities).to include('PU')
    expect(universities).to include('DU')
  end

  context 'weekly meals' do
    let(:nokogiri_element) do
      formatted_date = DateTime.now.monday.strftime('%Y-%m-%d')
      find("[data-meal-date='#{formatted_date}']").native
    end

    before(:each) do
      visit '/weekly/PU'
    end

    scenario 'User sees the meal date' do
      meal_date = nokogiri_element.css('h3').text
      formatted_date = DateTime.now.monday.strftime('%Y-%m-%d')
      expect(meal_date).to eq(formatted_date)
    end

    scenario 'User sees the periods' do
      lunch_period = nokogiri_element.css('h4')[0].text
      expect(lunch_period).to eq(Period.lunch.name)

      dinner_period = nokogiri_element.css('h4')[1].text
      expect(dinner_period).to eq(Period.dinner.name)
    end

    scenario 'User sees the dishes' do
      dinner_dishes = nokogiri_element.css('ul')[0].css('li')
      expect(dinner_dishes.size).to eq(1)
      expect(dinner_dishes.first.text).to eq('Rice')

      dinner_dishes = nokogiri_element.css('ul')[1].css('li')
      expect(dinner_dishes.size).to eq(2)
      expect(dinner_dishes.first.text).to eq('Rice')
    end
  end

  scenario 'User clicks the university' do
    visit '/'
    click_link('PU')
    expect(page).to have_current_path('/weekly/PU')
  end

  scenario 'User enters empty university' do
    visit '/weekly/void'
    expect(page.status_code).to eq(404)
  end

  scenario 'User returns right json to meals from university' do
    page.driver.header 'Accept', 'application/json'
    visit '/weekly/PU'
    response = JSON.parse(page.body.gsub('\"', '"')[1..-2])

    formatted_date = DateTime.now.monday.strftime('%Y-%m-%d')
    expect(response.first['meal_date']).to eq(formatted_date)
    # TODO: other expects
  end

  scenario 'User does ' do
    page.driver.header 'Accept', 'application/json'
    visit '/weekly/void'
    expect(page.status_code).to eq(404)
  end
end
