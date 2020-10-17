# frozen_string_literal: true

post '/google/token' do
  Session.s[:access_token] ||= SecureRandom.hex
  Session.s[:id_token] ||= SecureRandom.hex
  {
    access_token: Session.s[:access_token],
    expires_in: 32_400,
    scope: 'https://www.googleapis.com/auth/userinfo.email openid https://www.googleapis.com/auth/userinfo.profile',
    token_type: 'Bearer',
    id_token: Session.s[:id_token]
  }.to_json
end

get '/oauth2/v1/userinfo' do
  return {}.to_json unless Session.s[:access_token] == params[:access_token]

  {
    id: Session.s[:id_token],
    email: 'personal@gmail.com',
    verified_email: true,
    name: 'user name',
    given_name: 'user',
    family_name: 'name',
    picture: 'https://pic/url.jpg',
    locale: 'en'
  }.to_json
end

post '/refresh' do
  body = request.body.read
  error_msg = { error: 'invalid_grant', error_description: 'Token has been expired or revoked.' }.to_json

  return error_msg if body.empty?

  body = JSON.parse(body)

  return error_msg unless body['refresh_token'] == Session.s[:access_token]

  Session.s[:access_token] = SecureRandom.hex(Session.s[:access_token].size + 1)
  Session.s[:id_token] = SecureRandom.hex(Session.s[:id_token].size + 1)

  {
    access_token: Session.s[:access_token],
    expires_in: 3581,
    scope: 'openid',
    token_type: 'Bearer',
    id_token: Session.s[:id_token]
  }.to_json
end
