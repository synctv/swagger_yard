SwaggerYard::Engine.routes.draw do
   get '/doc', to: redirect('/swagger-ui/index.html')

   get '/api', to: 'swagger#index'
   get '/api/:resource', to: 'swagger#show'
end