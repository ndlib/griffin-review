# Reserves

## Run Book
The run book for Griffin (aka Reserves) is found in the [Technology Playbook](https://github.com/ndlib/TechnologistsPlaybook/blob/master/run-books/reserves.md) 

## Development Setup
1. bundle install
2. copy secrets.example.yml -> secrets.yml
3. check database config
4. Use db/open_reserves.sql to setup to databases called open_reserves and open_reserves_test
5. rake db:create db:migrate db:seed and setup test database
6. SSL=true bundle exec rails s

## Cron (scheduled jobs)
[Whenever gem](https://github.com/javan/whenever) is used to schedule recurring jobs. Here are jobs currently scheduled:
| Time | Description | Command |
| --- | --- | --- |
| 3:00 AM everyday | check for next semester in ND calendar | rake "semester:check" |
| 5:30 AM everyday |  | runner "BookReserveImporter.import!" |
| 1:15 AM everyday | check for published video reserves | runner "NotifyReserveRequestor.notify" |
### Cron Testing
1. To run a cronjob locally
```bundle exec rails runner -e development "NotifyReserveRequestor.notify"```

## Email
[Action Mailer](https://guides.rubyonrails.org/action_mailer_basics.html) is used to send out emails. It allows for multipart emails, attachments, testing, previews, and more.
### Email Testing
If [configured properly](https://guides.rubyonrails.org/action_mailer_basics.html#previewing-emails) you should be able to preview emails locally by firing up the application and going to this url
1. To preview the email - https://localhost:3011/rails/mailers/

## Rspec
To execute all test ```bundle exec rspec```
