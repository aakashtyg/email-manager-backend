# EmailManagerBackend

This a Ruby on Rails project to manage emails. API only. Its frontend can be found [here](https://github.com/aakash-cr7/email-manager-frontend).

## Running the app

```
redis-server
bundle install
rails s
```

## API endpoints

```POST /login ``` log user in
```DELETE /logout``` log user out
```POST /signup``` signup user
```GET /users``` get all user base
```GET /api/v1/emails``` get all emails of user
```POST /api/v1/emails``` add emails to db
```GET /api/v1/emails/${id}``` get a particular email based on id
```POST /api/v1/replies``` post a reply
```POST /api/v1/emails/${emailId}/assign_email_to_user``` assign a user to email

