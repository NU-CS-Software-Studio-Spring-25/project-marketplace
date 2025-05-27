Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'https://nu-cs-course-marketplace-a7681a168efe.herokuapp.com', 
            'http://localhost:3000', 
            'http://localhost:5000', 
            'https://localhost:3000',
            'https://localhost:5000'
    
    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true
  end
end
