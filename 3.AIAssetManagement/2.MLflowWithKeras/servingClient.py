import json
import numpy as np
import requests
data = json.dumps({"columns":["sl","sw","pl","pw"], "data":[[5.1,3.5,1.4,0.2]]})  #setosa
#data = json.dumps({"columns":["sl","sw","pl","pw"], "data":[[6.3,2.3,4.4,1.3]]})  #versicolor
#data = json.dumps({"columns":["sl","sw","pl","pw"], "data":[[6.3,2.5,5.0,1.9]]}) #virginica
headers = {"content-type": "application/json;format=pandas-split"}
json_response = requests.post('http://g1:9988/invocations',data=data, headers=headers)
#print(json_response) # 200 Success , 400 Fail
predictions = np.array(json.loads(json_response.text))
print(predictions)
result=np.argmax([i for i in predictions[0].values()])
#print(result)
decoder={0:"setosa",1:"versicolor",2:"virginica"}
print(decoder[result])
