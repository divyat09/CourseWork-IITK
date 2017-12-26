"""
BEFORE RUNNING:
---------------
1. If not already done, enable the Google Cloud Vision API
   and check the quota for your project at
   https://console.developers.google.com/apis/api/vision
2. This sample uses Application Default Credentials for authentication.
   If not already done, install the gcloud CLI from
   https://cloud.google.com/sdk/ and run
   'gcloud beta auth application-default login'
3. Install the Python client library for Google APIs by running
   'pip install --upgrade google-api-python-client'
"""

from pprint import pprint
import json
from googleapiclient import discovery
from oauth2client.client import GoogleCredentials

# Authentication is provided by the 'gcloud' tool when running locally
# and by built-in service accounts when running on GAE, GCE, or GKE.
# See https://developers.google.com/identity/protocols/application-default-credentials for more information.



# Construct the vision service object (version v1) for interacting
# with the API. You can browse other available API services and versions at
# https://developers.google.com/api-client-library/python/apis/
service = discovery.build('vision', 'v1', developerKey = 'AIzaSyDZUD_rDIjWvFOVEjBQPqSDDbF-sbk2lNM')

json_data=open('output.json').read()
temp = json.loads(json_data)
#batch_annotate_images_request_body = {
#{}
i=18
request = service.images().annotate(body=temp)
response = request.execute()
with open('features_'+str(i)+'.json', 'w') as outfile:
    json.dump(response, outfile)
# TODO: Change code below to process the 'response' dict:
pprint(response)
