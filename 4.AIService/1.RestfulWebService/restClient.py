import urllib
url = 'http://127.0.0.1:8888/getString'
u = urllib.urlopen(url)
data = u.read()# u is a file-like object
print data