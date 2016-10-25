import sys
import requests
import json

url = "%s/servicedef" % sys.argv[1]
auth = (sys.argv[2], sys.argv[3])
services = sys.argv[4].split(",")

print "Reading service definition"
sdefs = requests.get(url, auth=auth).json()

mapping = dict([[s["name"], i] for i,s in enumerate(sdefs)])

headers = {"Content-Type": "application/json"}

for service in services:
    sdef = sdefs[mapping[service]]
    sdef["options"]["enableDenyAndExceptionsInPolicies"] = "true"
    res = requests.put("%s/%s" % (url, sdef["id"]), data=json.dumps(sdef), auth=auth, headers=headers)
    print service, res.status_code