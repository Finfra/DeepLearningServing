# import urllib
# url = 'http://127.0.0.1:8888/post'
# u = urllib.urlopen(url)
# data = u.read()# u is a file-like object
# print data


from httplib2 import Http
from urllib import urlencode
h = Http()
data = dict(name="Joe", comment="A test comment")
resp, content = h.request("http://127.0.0.1:8888/post", "POST", urlencode(data))
print(content)