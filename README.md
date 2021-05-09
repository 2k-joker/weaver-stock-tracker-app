## NOTES
* This project is still a very long way from completion but it's live on [heroku](https://weaver-stock-tracker.herokuapp.com/)
* The UI is a mess but it works! The stock data is retrieved live from the [IEX cloud API](https://iexcloud.io/)
* ~~Stock lookup is only done by company's `ticker simbol` for now~~ UPDATE: Stock look up by `company name` is now LIVE!

## DEPENDECIES
* bootsnap (>= 1.1.0)
* bootstrap (~> 4.4.1)
* byebug
* capybara (>= 2.15)
* chromedriver-helper
* coffee-rails (~> 4.2)
* devise
* devise-bootstrap-views (~> 1.0)
* font-awesome-rails
* iex-ruby-client
* jbuilder (~> 2.5)
* jquery-rails
* listen (>= 3.0.5, < 3.2)
* pg (for `production`)
* puma (~> 3.11)
* rails (~> 5.2.4, >= 5.2.4.3)
* sass-rails (~> 5.0)
* selenium-webdriver
* spring
* spring-watcher-listen (~> 2.0.0)
* sqlite3 (for `development`)
* turbolinks (~> 5)
* tzinfo-data
* uglifier (>= 1.3.0)
* web-console (>= 3.3.0)

## DEVELOPMENT
* Clone the repo:
  * **HTTP:** `git clone https://github.com/2k-joker/weaver-stock-tracker-app.git`
  * **SSH:** `git clone git@github.com:2k-joker/weaver-stock-tracker-app.git`
* Run `bundle install --without production` to install gems
  * It's ideal to use the `--without production` flag everytime you add new gems so that only gems required for dev are installed
* Run `rails db:migrate` to run database migrations
* Follow instructions in the [iex-ruby-client](https://github.com/dblock/iex-ruby-client#usage) gem docs to create an account and obtain your own creds.
  * Make sure to use your sandbox creds and follow best practices for storing sensitive data in public apps (e.g using ENV vars)
* Run `rails s` to start a local dev server
* The app should be running on `localhost:3000`

## CONTRIBUTING
* Bug reports and [pull requests](https://github.com/2k-joker/weaver-stock-tracker-app) on Github are more than welcome
* The front-end needs ~~complete rework~~ a ton of work/optimization
