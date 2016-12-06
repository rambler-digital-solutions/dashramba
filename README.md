### Overview
[![Build Status](https://travis-ci.org/rambler-ios/dashramba.svg?branch=develop)](https://travis-ci.org/rambler-ios/dashramba)

Project information dashboard with a number of integrations used in iOS development. Built using [Dashing](http://dashing.io).

![Dashramba](https://i.imgur.com/hSy2gi6.png)

### Integrations

> The project is still in development - so a lot more integrations are ready to come!

- AppStore
  - Average rating for the latest version
  - All reviews for the given country
- Jenkins
  - Number of unit tests
- Fabric
  - Crashfree percentage for all builds for the last 30 days
  - OOM-free percentage for all builds for the last 30 days
- OCLint
  - OCLint issues
  - Xcode warnings

### Usage

The usage is a bit complicated right now, we'll simplify it in the future stable versions:

1. Clone this repository
2. Add `.env` file in the root directory:

  ```yml
  JENKINS_URL={jenkins_url_here}
  JENKINS_USERNAME={jenkins_username_here}
  JENKINS_PASSWORD={jenkins_password_here}
  ```
  
3. Add `fabric.yml` file in the root directory:

  ```yml
  fabric_email: {fabric_login_here}
  fabric_password: {fabric_password_here}
  fabric_client_id: {fabric_client_id_here}
  fabric_client_secret: {fabric_client_secret_here}
  fabric_organization_id : {fabric_organization_id_here}
  ```
4. Add `analyzer.yml` file in the root directory:

   ```yml
   report_url: '{oclint_reports_url_here}'
   ```
5. Replace the application data in `config.yml` with your applications.
6. Run `dashing start`.  

### Installation

1. Clone this repository
2. Install `dashing` gem: `gem install dashing`
3. Run `bundle install` in dashramba root directory.

### License

MIT

### Authors

Egor Tolstoy, Vadim Smal, Catherine Korovkina and the rest of Rambler.iOS team.
