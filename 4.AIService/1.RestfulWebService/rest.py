#!/usr/bin/env python
# http://www.dreamsyssoft.com/blog/blog.php?/archives/6-Create-a-simple-REST-web-service-with-Python.html
import web
import time,random

urls = (
    '/getString', 'getString',
    '/post', 'getString'
)

app = web.application(urls, globals())

class getString:        
    def GET(self):
        r=random.random()
        now = time.localtime()
        nows = "%04d-%02d-%02d %02d:%02d:%02d" % (now.tm_year, now.tm_mon, now.tm_mday, now.tm_hour, now.tm_min, now.tm_sec)
        output = '{"time":"%s","y":%f}'%(nows,r)
        return output
    def POST(self):
        str1=web.data() 
        return str1

if __name__ == "__main__":
    app.run()
