# OpenID Consumer library for sinatra
# by deepblue (http://myruby.net)

%w(openid openid/extensions/sreg openid/store/memory uri).each{|lib| require lib}

module OpenIdAuthentication
  
  ###########################################################################
  # Template Methods
  def begin_openid_authentication(openid = nil)
    openid ||= params[:openid_identifier]
    oidreq = openid_consumer.begin(openid) 
  
    oidreq.add_extension(sreg_request) if respond_to?(:sreg_request)
    yield(oidreq) if block_given?
      
    if oidreq.send_redirect?(realm, url_for_complete, params[:immediate])
      #redirect_to url_for_openid_challenge(ret, params[:openid_identifier])
      url = openid_reqeust_url(oidreq.redirect_url(realm, url_for_complete, params[:immediate]), openid)
      redirect url
    else
      @form_text = oidreq.form_markup(realm, url_for_complete, params[:immediate], {'id' => 'openid_form'})
      erb begin_template
    end
  end
  
  def complete_openid_authentication
    oidresp = openid_consumer.complete(openid_params, request.url)    
    
    if oidresp.status == OpenID::Consumer::SUCCESS
      authentication_succeed(oidresp)
    else
      authentication_failed(oidresp, message_from_response(oidresp))
    end
  end
  
  ###########################################################################
  # You can override this methods   
  
  def authentication_succeed(oidresp)
  end
  
  def authentication_failed(oidresp, message)
  end
  
  def openid_consumer
    @openid_consumer ||= OpenID::Consumer.new(session, openid_store)
  end
  
  def openid_store
    OpenID::Store::Memory.new
  end
  
  def url_for_complete
    uri = URI.parse(request.url)
    uri.path = '/openid/complete'
    uri.to_s
  end
    
  def realm
    uri = URI.parse(request.url)
    uri.path = '/'
    uri.query = nil
    uri.to_s
  end
    
  def openid_reqeust_url(url, openid)
    url
  end
  
  ###########################################################################
  # Internal Helper Methods
private
  
  def openid_params
    params
  end
  
  def message_from_response(oidresp)
    case oidresp.status
    when OpenID::Consumer::FAILURE
      oidresp.display_identifier ? 
        "Verification of #{oidresp.display_identifier} failed: #{oidresp.message}" : 
        "Verification failed: #{oidresp.message}" 
    when OpenID::Consumer::SETUP_NEEDED
      "Immediate request failed: Setup needed"
    when OpenID::Consumer::CANCEL
      "Verification cancelled."
    when OpenID::Consumer::SUCCESS
      "Verification of #{oidresp.display_identifier} succeeded."
    else
      "Unknown response status: #{oidresp.status}"
    end
  end  
  
  def begin_template
    ret = <<-END
      <html><body>
        <%= @form_text %>
        <script type="text/javascript">
            document.getElementById('openid_form').submit();
        </script>
      </body></html>
    END
  end
  
  def sreg_data(oidresp)
    OpenID::SReg::Response.from_success_response(oidresp).data
  rescue Object
    {}
  end
end
Sinatra::EventContext.send :include, OpenIdAuthentication




##################################################
# Action URL

Sinatra.application.define_event(:post, '/openid/begin') do
  begin_openid_authentication(params[:openid_identifier])
end

Sinatra.application.define_event(:get, '/openid/complete') do
  complete_openid_authentication
end

Sinatra.application.define_event(:post, '/openid/complete') do
  complete_openid_authentication
end

