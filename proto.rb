class API < ProperNoun
  before { 'lol' }
  after { 'ok' }

  # Helpers: Just put in a def to the object directly
  # Configure: Ditto

  resource :widgets do
    before { 'for resource' }
    after { 'for resourse' }
    
    # GET /widgets.json
    collection do
    end
    
    # GET /widgets/:id.json
    member do
    end
    
    # PUT /widgets/:id
    # POST /widgets/:id/update
    # POST /widgets/:id=
    member :update do  
    end
    
    # DELETE /widgets/:id
    # POST /widgets/:id/delete
    # POST /widgets/:id?_method=DELETE
    member :delete do
    end
    
    ##
    ## CUSTOM STUFF
    ##
    
    # PUT /widgets/:id/flag
    member_put :flag do
      
    end
    
    # Errors
    
    # GET /widgets/nasty.:format
    collection :nasty do
      # error 'nasty_blast', 'Nasty Nate forgot to take a shower'  # defaults to 500
      # error 401, 'not_authorized', 'You didn't authorize the shit!
    end
    
  end

  get '/'
    # turns into: get '/widgets.:format' do
    'ok'
  end
end

=begin
?format=xml|json

resource_routes => {'widgets' => [
  ['collection', 'index', block]          # GET /widgets
  ['collection', 'action', block]         # GET /widgets/action
  ['collection', 'create', block]         # POST /widgets
  ['member', 'update', block]             # POST /widgets/:id             ||  PUT /widgets/:id
  ['member', 'flag', block]               # PUT /widgets/:id
  ['member', 'show', block]               # GET /widgets/:id
  ['member', 'delete', block]             # POST /widgets/delete/:id
]}
=end