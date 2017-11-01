#!/usr/local/bin/python

from google.cloud import storage
import os, json, pprint, sys, six
import recursion as recursion

image = "IMG_0174.JPG"
directory = os.path.dirname(sys.argv[0])

def readConfig(file_name):
	
	f = open(file_name, "r")
	output = f.read()
	f.close()
	return output

def getFirestoreClient():
	"""Returns handler to firestore DB """
	user = os.environ["USER"]
	os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = directory + "/config/MobileFunStore-00c13bb44bf4.json"

	return storage.Client()

def uploadFile(fileName, client, bucket, reSave=False):
	blob2 = bucket.blob('images/' + fileName)
	file_exist = blob2.exists()
	if file_exist == False or \
		(file_exist == True and reSave == True):
		blob2.upload_from_filename(filename='./images/' + fileName)

		print "=> Uploading", imageName
	else:
		print "=> Skipped :", imageName, " already exists"


	# Note: 
	# It is useless url as it refers to https://storage.googleapis.com/
	# w/o certificate I cannot access it from app
	#
	# url = blob2.public_url
	# if isinstance(url, six.binary_type):
	# 	url = url.decode('utf-8')
	# print url


########### MAIN ################	
if __name__ == "__main__":


	# Read config
	output = readConfig("storeDataStructure.json")
	data = json.loads(output)

	# # Parse data
	reference = "products"
	recursion.recursion(data, 0, "", 0)
	client = getFirestoreClient()
	bucket = client.get_bucket('mobilefuntemplate1.appspot.com')
	print bucket

	# exit(1)
	for key, group in recursion.group_list.iteritems():	

		imageName = group["imageName"]
		if imageName != "":
			uploadFile(imageName, client, bucket)

	print ">>>>  END  <<<<"










