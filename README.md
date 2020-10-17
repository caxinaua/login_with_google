
# login\_with\_google

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'login_with_google'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install login_with_google
    
    
Generate config file

	$ bundle exec login_with_google:g

## Creating your credentials

[Full steps to create your credentials](creating_credentials.md)

#### Add credentials and redirect_uri to env

```
export G_CLIENT_ID='client_id'
export G_CLIENT_SECRET='client_secret'
export G_REDIRECT_URI='http://localhost:3000/callback'
```

## Usage

#### Url to login

```ruby
LoginWithGoogle::Api.url_in
```

#### Url to login with helper

```ruby
g_url_in
```


#### Process callback

Get auth return keys `access_token expires_in scope token_type id_token`

```ruby
@auth = LoginWithGoogle::Api.auth code: params[:code]
```

Get user info return keys `id email verified_email name given_name family_name picture locale`

```ruby
@info = LoginWithGoogle::Api.info @auth
```

#### Refresh a token

Pass a `access_token` from `@auth` and receive a keys `access_token expires_in scope token_type id_token`

```ruby
@refresh = LoginWithGoogle::Api.refresh(token: @auth['access_token'])
```