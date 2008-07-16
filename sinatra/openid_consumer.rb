# OpenID Consumer sample application built with sinatra
# by deepblue (http://myruby.net)

%w(rubygems sinatra haml).each{|lib| require lib}

get '/' do
  haml :login
end

load File.dirname(__FILE__) + '/lib/openid_authentication.rb'

module OpenIdAuthentication
  def authentication_succeed(oidresp)
    nickname = sreg_data(oidresp)['nickname']
    @message = "Logged in as #{nickname}(#{oidresp.display_identifier})"
    haml :login
  end

  def authentication_failed(oidresp, message)
    @message = "FAILED!!"
    haml :login
  end
  
  def sreg_request
    OpenID::SReg::Request.new(%w(nickname))
  end
end

use_in_file_templates!

__END__

## layout
%html
%body
  =yield

## login
%h1= @message || 'Login'
%form{:action => '/openid/begin', :method => 'post'}
  %input{:name => 'openid_identifier'}
  %input{:type => 'submit'}