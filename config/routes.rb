CompanyFinderServer::Application.routes.draw do
  root 'companies#find'
  get 'find' => 'companies#find'
end
