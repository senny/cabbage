#!/usr/bin/python

DEFAULT_USERNAME = 'zopemaster'
DEFAULT_PASSWORD = 'admin'
DEFAULT_HOSTNAME = 'localhost'
DEFAULT_PORT = '8080'

VERSION = '0.1'

import re
import sys
import base64
import urllib, urllib2
from optparse import OptionParser

# set up a parser
parser = OptionParser(usage='%prog [-z|-c] [options]', version=VERSION)
# options:
parser.add_option('-z', '--zcml', dest='zcml',
                  action='store_true',
                  help='Reload Code & ZCML')
parser.add_option('-c', '--code', dest='code',
                  action='store_true',
                  help='Reload Code only (Default)')
parser.add_option('-u', '--user', dest='user',
                  action='store', default=DEFAULT_USERNAME,
                  help='Zope-Username for logging into ZMI (Default: %s)' %
                  DEFAULT_USERNAME)
parser.add_option('-p', '--pass', dest='passwd',
                  action='store', default=DEFAULT_PASSWORD,
                  help='Passwort for user defined with --user (Default: %s)' %
                  DEFAULT_PASSWORD)
parser.add_option('-H', '--host', dest='host',
                  action='store', default=DEFAULT_HOSTNAME,
                  help='Host to connect with (Default: %s)' % DEFAULT_HOSTNAME)
parser.add_option('-P', '--port', dest='port',
                  action='store', default=DEFAULT_PORT,
                  help='Port on which Zope runs (Default: %s)' % DEFAULT_PORT)


options, args = parser.parse_args()

# action to send to plone.reload
action = 'code'
if options.code and options.zcml:
    print 'ERROR: You can use -z and -c together.'
    sys.exit(0)
elif options.zcml:
    action = 'zcml'

# generate credentials cookie (__ac)
ac_value = options.user.encode('hex') + ':' + options.passwd.encode('hex')
ac_value = str( base64.encodestring(ac_value) ).strip()

# prepare url
url = 'http://%s:%s/@@reload' % (
    options.host,
    options.port
    )

# prepare request
headers = {
    'Cookie' : '__ac=' + ac_value,
    }

# send request
data = {
    'action': action,
    }
request = urllib2.Request(url, urllib.urlencode(data), headers)
response = urllib2.urlopen(request)
html = response.read()

# print response
xpr = re.compile('<pre.*?>(.*?)</pre>', re.DOTALL)
match = xpr.search(html)
if match:
    print match.groups()[0]
else:
    print html
