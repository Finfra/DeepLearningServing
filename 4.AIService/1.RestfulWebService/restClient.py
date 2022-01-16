from urllib.request import urlopen
url = 'http://127.0.0.1:8888/getString'
u = urlopen(url)
data = u.read()# u is a file-like object
print(data)
