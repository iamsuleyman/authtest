Rails.application.routes.draw do
  use_doorkeeper do
    controllers tokens: "custom_tokens"
  end
end
