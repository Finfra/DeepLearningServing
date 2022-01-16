from httplib2 import Http
from urllib.parse import urlencode
h = Http()
data = dict(name="Joe", comment="A test comment")
resp, content = h.request("http://127.0.0.1:8888/post", "POST", urlencode(data))
print(content)
