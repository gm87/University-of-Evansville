class WelcomeController < ApplicationController
  http_basic_authenticate_with name: "heydad", password: "sportsball"
  
  def index
  end
end
