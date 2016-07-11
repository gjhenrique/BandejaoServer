Bandejao is a collaborative project that fetches and provides the weekly menu of university cafeterias through an API.

Its prime objective is the easy inclusion of new university cafeterias.

## Architecture
Since the idea is to support many universities, the code has to be modular and generic.
To illustrate, here is an overview of the components of this architecture:

<br/>
![](architecture.png)
<br/>

### [Parsers](parsers/)
Visits the university website and parses its content, creating the [meals](models/meal.rb) and [dishes](models/dish.rb) objects.
Each university has its parser.

### [Parser Job](jobs/parser_job.rb)
Calls all the registered parsers and process the meals returned from them.
If there is any update, the menu is stored in the database. 

### [Scheduler](config/schedule.rb)
With the help of [whenever](https://github.com/javan/whenever) and [cron](https://en.wikipedia.org/wiki/Cron), the Parser Job is invoked periodically.

### [Database](db/schema.rb)
Since we will not have "big data" and many concurrent writes, Sqlite will [fit like a glove](http://www.sqlite.org/whentouse.html).

### [Businness logic](models/)
Handles the domain logic like selecting only the meals for this week, filtering duplicated meals.

### [API](controllers/app.rb)
Nothing fancy. [Sinatra](http://www.sinatrarb.com) routes and that's it! Check the API [documentation](http://docs.bandejao.apiary.io) for more details.
    
### Clients
With an available API, the sky is the limit. We can have iOS, Android and web clients.

## How to develop your own parser

<br/>
![](parser_highlight.png)
<br/>

As an example, we are going to build a parser for a fake university (Programming University)
The first step is to insert the university information in the [universities.yml](config/universities.yml) file

```yaml
# Generally, the name is the initials of the university
PU:
  long_name: Programming University
  website: http://pu.org
  # By convention, the class should be inside the Parser module.
  # Also, the class name of the parser is the name of the university constantized followed by Parser 
  # For this case, the class you should create is Parser::PuParser 
  # Only insert this property if you want a different class name or structure
  # class_name: DifferentClassParser
```

Let's imagine that the weekly menu is represented by table:

| | | |
|-----------------|---|---|
| 02/21  |  Tomato Soup | Roasted Carrot  |
| 02/22 |  Potato Pie  |  Meat Lasagna |

This table is represented by the following html:

```html
<table class="weekly_menu">
  <tr>
    <td>Monday - 02/21</td>
    <td>Tomato Soup</td>
    <td>Roasted Carrot</td>
  </tr>
  <tr>
    <td>Tuesday - 03/21</td>
    <td>Potato Pie</td>
    <td>Meat Lasagna</td>
  </tr>
</table>
```

To convert this raw html to our domain objects, the parser class has the following requirements:

* Implements the parse method
* The parse method should return a list of [Meal](models/meal.rb) objects

For example, the parser for this university would be:

```ruby
# By convention, the class should be a part of the Parser module. 
# Also, the convention dictates that the name is the name of the university followed by the Parser (PuParser)
module Parser
  class PuParser

    # This is the URL where the menu is located
    URL =  'http://pu.org/menu'

    def parse
      # fetch_html is a helper that returns a Nokogiri document
      doc = fetch_html URL

      # You can use Nokogiri xpath and css selectors normally
      html_rows = doc.css 'table.weekly_menu tr'

      html_rows.map do |tr|
        # Discarding the empty elements
        tds = tr.children.reject { |td| td.text.squish.empty? }
        # For the html, the date is always in the first column
        html_date = tds.first.text
        # Cast from string to Ruby object
        date = DateTime.strptime html_date, '%M/%d'

        # We iterate over the rest of the columns to get the dishes
        dishes = tds[1..-1].map do |html_dish|
          Dish.new(name: html_dish.text)
        end

        # Period.lunch because we know that the menu is only for the lunch
        Meal.new(meal_date: date, dishes: dishes, period: Period.lunch)
      end
    end
  end
end
```

Then, to test our code, we have to run the following commands:

```bash
# Typical Ruby and ActiveRecord application
# Install dependencies
bundle install
# Create and migrate database
bundle exec rake db:create && migrate
# Load all the universities, including Programming University, from the universities.yml file
bundle exec rake db:seed
# Run the Programming University parser
bundle exec rake "parsers:parse_university[pu]"
# Run the server
bundle exec rackup
# Check the results
curl localhost:9292/weekly/pu
```

Nice! With only this code, we have scheduling, comparison of incoming meals, real-time notification with [GCM](https://developers.google.com/cloud-messaging/) [topics](https://developers.google.com/cloud-messaging/topic-messaging) and an API with the latest weekly menu of your university. 
Everything out of the box.

Also, this is a collaborative project, so you don't need to host the server (only if you want it!).
Just send a pull request and your university will be included in [bandejao.gjhenrique.com](https://bandejao.gjhenrique.com).

## Related projects

* [Deploy](https://github.com/gjhenrique/BandejaoDeploy)
* [Android](https://github.com/pedro-stanaka/cardapio-ru-uel)
* iOS client - Don't know when. =P
