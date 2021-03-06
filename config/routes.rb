ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  # map.connect '', :controller => "welcome"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  # map.connect ':controller/service.wsdl', :action => 'wsdl'

  map.connect '/', :controller => 'main', :action => 'index'
  map.connect 'developer', :controller => 'main', :action => 'developer'
  map.connect ':release/download.js', :controller => 'main', :action => 'download_js'
  map.connect '122', :controller => 'main', :action => :index
  map.connect '122/:lang', :controller => 'main', :action => 'release', :release => "122"
  map.connect '121/:lang', :controller => 'main', :action => 'release', :release => "121"
  map.connect '114/:lang', :controller => 'main', :action => 'release', :release => "114", :outdated => true
  map.connect '113/:lang', :controller => 'main', :action => 'release', :release => "113", :outdated => true

  #map unavailable version to the latest release
  map.connect ':version/:lang', :controller => 'main', :action => 'release', :release => "122", :requirements => { :version => /[\d]+/ }

  map.connect 'developer/:lang', :controller => 'main', :action => 'release', :release => "developer"

  map.connect 'search', :controller => 'search', :action => 'searchresult'
  map.connect 'package/:package', :controller => 'package', :action => 'show', :requirements => { :package => /[\w\-\.:\+]+/ }
  map.connect 'package/thumbnail/:package.png', :controller => 'package', :action => 'thumbnail', :requirements => { :package => /[\w\-\.:\+]+/ }
  map.connect 'package/screenshot/:package.png', :controller => 'package', :action => 'screenshot', :requirements => { :package => /[\w\-\.:\+]+/ }

  map.connect 'packages', :controller => 'package', :action => 'categories'
  map.connect 'appstore', :controller => 'package', :action => 'categories'
  map.connect 'appstore/:category', :controller => 'package', :action => 'category', :requirements => { :category => /[\w\-\.: ]+/ }

  map.connect 'promodvd', :controller => 'order', :action => 'new'
  map.connect 'promodvds', :controller => 'order', :action => 'new'
  
  map.connect 'ymp/:project/:repository/:package.ymp', 
    :requirements => { :project => /[\w\-\.:]+/, :repository => /[\w\-\.:]+/, :package => /[\w\-\.:\+]+/ },
    :controller => 'main', :action => 'ymp_without_arch_and_version'
  map.connect 'ymp/:project/:repository/:arch/:binary.ymp',
    :requirements => { :project => /[\w\-\.:]+/, :repository => /[\w\-\.:]+/, :arch => /[\w\-\.:]+/, :binary => /[\w\-\.:\+]+/ },
    :controller => 'main', :action => 'ymp_with_arch_and_version'

  map.connect '/codecs', :controller => 'codecs', :action => 'index'

  # compatibility routes for old download implementation
  map.connect '/download', :controller => 'download', :action => :package
  map.connect '/download.:format', :controller => 'download', :action => :package
  map.connect '/download/iframe', :controller => 'download', :action => :package, :format => 'iframe'
  map.connect '/download/json', :controller => 'download', :action => :package, :format => 'json'

  map.connect '/download/:action.:format', :controller => 'download'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
