
Doorkeeper.configure do
  orm :active_record

  api_only
  base_controller "ActionController::API"

  resource_owner_authenticator do
    puts "FUCK"
    User.first
    # Rails.logger.info "========== resource_owner_authenticator =========="
    # authenticate_with_jwt
    # Поскольку в маркет сервисе пользователи не создаются напрямую, этот блок можно оставить пустым или настроить для другой логики.
  end

  resource_owner_from_credentials do
    puts "FUCK2"
    User.first
    # Этот блок тоже можно оставить пустым, так как пользователи не будут авторизовываться через email и пароль.
  end

  grant_flows %w[custom_strategy]

   access_token_expires_in 2.hours
   use_refresh_token

  grant_flows %w[authorization_code client_credentials password custom_credentials]
  reuse_access_token
end
