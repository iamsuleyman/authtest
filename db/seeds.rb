Doorkeeper::Application.create!(
  name: "patient",
  redirect_uri: "urn:ietf:wg:oauth:2.0:oob",
  app_uri: "http://localhost:3000",
  confidential: true
)

Doorkeeper::Application.create!(
  name: "provider",
  redirect_uri: "urn:ietf:wg:oauth:2.0:oob",
  app_uri: "http://localhost:3001",
  confidential: true
)
