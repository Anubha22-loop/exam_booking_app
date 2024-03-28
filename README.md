# Exam Booking APP

### Requirements:

* Ruby version -- 3.2.2
  * `brew install rbenv`
  * follow whatever is in `rbenv init`
  * Restart terminal
  * `rbenv insatll 3.2.2`
* Rails version -- 7.0.8
  * `gem install rails --version 7.0.8`

### Setup

1. git clone <this project's url>
2. bundle install
3. bundle exec rake db:create`
4. bundle exec rake db:migrate`
5. `rspec` to run all test cases

### API's

1. /api/users - To create exam booking either by creating user or finding existing user
2. /api/exams - To record exams in the db
3. /api/colleges - To record college in the db
4. /api/exam_windows - To record exam window related to exams in the db



