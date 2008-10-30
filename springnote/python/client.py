'''
Example consumer for springnote.com
'''
import httplib
import time
import oauth

SPRINGNOTE_PROTOCOL = 'http'
SPRINGNOTE_SERVER = 'api.springnote.com'
SPRINGNOTE_PORT = 80

REQUEST_TOKEN_URL = 'https://api.openmaru.com/oauth/request_token'
ACCESS_TOKEN_URL = 'https://api.openmaru.com/oauth/access_token/springnote'
AUTHORIZATION_URL = 'https://api.openmaru.com/oauth/authorize'


class SpringnoteClient(oauth.OAuthClient):
    def __init__(self, consumer_token, consumer_secret):
        self.consumer_token = consumer_token
        self.consumer_secret = consumer_secret
        self.signature_method = oauth.OAuthSignatureMethod_HMAC_SHA1()
        self.consumer = oauth.OAuthConsumer(self.consumer_token, self.consumer_secret)
        
    def fetch_request_token(self):
        oauth_request = oauth.OAuthRequest.from_consumer_and_token(self.consumer, http_url=REQUEST_TOKEN_URL)
        oauth_request.sign_request(self.signature_method, self.consumer, None)

        connection = httplib.HTTPSConnection("%s:%d" % ('api.openmaru.com', 443))
        connection.request(oauth_request.http_method, REQUEST_TOKEN_URL, headers=oauth_request.to_header()) 
        response = connection.getresponse()
        return oauth.OAuthToken.from_string(response.read())

    def authorize_url(self, token, callback=None):
        ret = "%s?oauth_token=%s" % (AUTHORIZATION_URL, token.key)
        if callback:
            ret += "&oauth_callback=%s" % escape(callback)
        return ret
        
    def fetch_access_token(self, token):
        oauth_request = oauth.OAuthRequest.from_consumer_and_token(self.consumer, token=token, http_url=ACCESS_TOKEN_URL)
        oauth_request.sign_request(self.signature_method, self.consumer, None)

        connection = httplib.HTTPSConnection("%s:%d" % ('api.openmaru.com', 443))
        connection.request(oauth_request.http_method, ACCESS_TOKEN_URL, headers=oauth_request.to_header()) 
        response = connection.getresponse()
        self.access_token = oauth.OAuthToken.from_string(response.read())
        return self.access_token
    
    def set_access_token(self, token, key):
        self.access_token = oauth.OAuthToken(token, key)
        return self.access_token
        
    def get_page(self, page_id, domain=None):
        url = "%s://%s/pages/%d.xml" % (SPRINGNOTE_PROTOCOL, SPRINGNOTE_SERVER, page_id)
        parameters = {}
        if domain:
            parameters['domain'] = domain
            url += "?domain=%s" % domain
        
        print url
        oauth_request = oauth.OAuthRequest.from_consumer_and_token(self.consumer, token=self.access_token, http_method='GET', http_url=url, parameters=parameters)
        oauth_request.sign_request(self.signature_method, self.consumer, self.access_token)        

        connection = httplib.HTTPConnection("%s:%d" % (SPRINGNOTE_SERVER, SPRINGNOTE_PORT))
        connection.request('GET', url, headers=oauth_request.to_header())
        return connection.getresponse().read()
                
def run_example():
    
    # setup
    CONSUMER_TOKEN  = 'YOUR TOKEN'
    CONSUMER_SECRET = 'YOUR SECRET'
    client = SpringnoteClient(CONSUMER_TOKEN, CONSUMER_SECRET)

    # get request token
    print '* Obtain a request token ...'
    pause()
    token = client.fetch_request_token()
    print 'GOT'
    print 'key: %s' % str(token.key)
    print 'secret: %s' % str(token.secret)
    pause()
    
    print '* Authorize the request token ...'
    print 'please visit %s in your browser and press any key.' % client.authorize_url(token)
    raw_input('...')
    pause()
    
    # get access token
    print '* Obtain an access token ...'
    pause()
    token = client.fetch_access_token(token)
    print 'GOT'
    print 'key: %s' % str(token.key)
    print 'secret: %s' % str(token.secret)
    pause()
        
    # access some protected resources
    print '* Access protected resources ...'
    pause()
    print client.get_page(144, 'deepblue')
    pause()

def pause():
    print ''
    time.sleep(1)

if __name__ == '__main__':
    run_example()
    print 'Done.'