# SNLTube

SNLTube is a Rails 6.0.3 application that runs on Ruby 2.6.5 and allows a
visitor to list and watch SNL video extracts. It connects to the Zype API and
leverages on its OAuth mechanism for authentication and authorizaton to access
premium content.

It operates as a SPA and its front-end is created with Vue.js integrated
directly via the Webpacker gem. It uses the css framework Bootstrap v5 alpha
and Fontawesome v5 for icons.

The application is online hosted at heroku:

                    https://snl-tube.herokuapp.com/

## High level architecture

As a SPA, the application loads the Vue.js app at start and the internal
Vue router (https://router.vuejs.org/) dynamically loads the correct page
component dependending on the url matched.

Those page components then hit the application JSON API that supplies them
with the data provided from the Zype API endpoint. The relevant endpoints are
all nested on the API namespace: `/api/videos` and `/api/videos/:id`.

The controllers in the API endpoints interact with a set of services objects
that abstract the Zype API hiding the low level details and lowering the
coupling with API.

All the classes under the `Zype::` module namespace could be considered for
extraction to a gem in the future if multiple apps need to interact with the
Zype API. Their only dependency is the Faraday gem for performing HTTP REST
requests.

## Testing

### System or Feature tests

There is a reasonable set of feature specs that exercise the application
use cases. Those leverage on Capybara and chromedriver; the HEADLESS
environment flag can be used to make the browser visible:

`$ HEADLESS=false bundle exec rspec spec/features`

I've used the VCR gem (https://github.com/vcr/vcr) to record the HTTP
interactions with the Zype API and replay them while testing the app. This
allows for faster and more robust tests that do not depend directly of the
status of the services to pass but still provides a very realistic mocking.

### Zype facade tests

There are a set of tests that exercise the Zype service objects that interact
with the API and that use direct object mocking. Of special relevance is the
`Zype::Auth::Session` class that abstracts the concept of the Zype access token
and allows for transparent renewal if it when is expired via the refresh token.
