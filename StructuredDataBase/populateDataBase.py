#!/usr/local/bin/python

from google.cloud import firestore
import os, json, pprint, sys
import recursion as recursion
import pyrebase


######################################################################################################
# Important remark: Before you start create below files and populate them with data
#
#	firebaseConfig.json 	-> Data needed for firebase project identification
#	credentials.json 		-> login/password for authentication throughout pyrebase
#	MobileFunStore-fdf9f054b682.json 	->	key and data for authentication throughout firestore
#
######################################################################################################


directory = os.path.dirname(sys.argv[0])

# IMPORTANT REMARK: 
# Due to security reason credentials are kept in separate file which is called "credentials"
# Information should be stored there in format: "login|password"
class FirebaseManager(object):
	"""docstring for FirebaseManager"""

	login = ""
	password = ""
	firebase = None
	userIdToken = None

	def __init__(self, login=None, password=None):

		credentials = self.getCredentials()
		self.firebase = self.getFirebaseClient()

		###### AUTHENTICATION ############
		# Get a reference to the auth service
		auth = self.firebase.auth()

		# Log the user in
		user = auth.sign_in_with_email_and_password(credentials["login"], credentials["password"])
		# Refresh token as it can expire after 1 hour
		user = auth.refresh(user['refreshToken'])
		# now we have a fresh token
		self.userIdToken = user['idToken']

		# ######## DATABASE #####################
		# # Get a reference to the database service
		# self.db = firebase.database()

	def getCredentials(self):

		file_name = "./config/credentials.json"
		credentials = ""
		with open(file_name, 'r') as json_file:
			credentials = json.load(json_file)

		return credentials	

	def getFirebaseClient(self):
		"""Returns handler to firebase storage """
		file_name = "./config/firebaseConfig.json"
		firebaseConfigFile = ""
		with open(file_name, 'r') as json_file:
			firebaseConfig = json.load(json_file)
			# print firebaseConfig

		return pyrebase.initialize_app(firebaseConfig)	

## end class


def readConfig(file_name):
	
	f = open(file_name, "r")
	output = f.read()
	f.close()
	return output

def saveConfig(config, file_name):
	serialized = json.dumps(config)
	with open(file_name, 'w') as file:
		file.write(serialized)


def getFirestoreClient():
	"""Returns handler to firestore DB """
	user = os.environ["USER"]
	os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = directory + "/config/MobileFunStore-fdf9f054b682.json"

	return firestore.Client()


def delete_collection(coll_ref, batch_size):

    docs = coll_ref.limit(10).get()
    deleted = 0

    for doc in docs:
        print(u'    Deleting doc {} => {}'.format(doc.id, doc.to_dict()["title"]))
        doc.reference.delete()
        deleted = deleted + 1

    if deleted >= batch_size:
        return delete_collection(coll_ref, batch_size)	

def parse_and_save_group_object(group):

	print "    Adding", group["id"], "=>", group["title"]
	doc_ref = firestore.DocumentReference("Groups", group["id"], client=client)
	if "parent_id" in group and group["parent_id"] != "":
		parent = firestore.DocumentReference("Groups", group["parent_id"], client=client)
		group["parent_ref"] = parent
		
	# remove uneeded data from dict
	del group["is_group"]
	# del group["parent_id"]
	# print type(group), group
	doc_ref.set(group)





########### MAIN ################	
if __name__ == "__main__":


	pp = pprint.PrettyPrinter(indent=4)
	client = getFirestoreClient()
	# doc_ref = client.collection('Groups') 

	# Read config
	output = readConfig("storeDataStructure.json")
	data = json.loads(output)

	# Parse data
	reference = "products"
	recursion.recursion(data, 0, "", 0)

	# print recursion.group_list
	firebaseMananger = FirebaseManager()
	child = "Lenses.jpg"

	print "=> Obtaing images urls"
	imageDirectory = "images"
	for key, group in recursion.group_list.iteritems():	
		imageURL = ""
		if "imageName" in group and group["imageName"] != "":
			child = imageDirectory + "/" + group["imageName"]
			imageURL = firebaseMananger.firebase.storage().child(child).get_url(token=None)
		group["url"] = imageURL.decode("utf-8")


	# Validate data
	# Check all mandatory field are there
	print "=> Checking mandatory fields"
	mandatory_fields = ["title", "order", "level", "imageName", "final", "id", "shortDescription", "longDescription"]
	not_empty_fields = ["shortDescription", "longDescription", "imageName"]
	for key, group in recursion.group_list.iteritems():
		
		recursion.checkMandatoryFields(mandatory_fields, not_empty_fields, group)

	## Make copy
	original_data = dict(recursion.group_list)

	## CLEAR old Groups
	print "=> Deleting old documents"
	group_ref = firestore.CollectionReference("Groups", client=client)
	delete_collection(group_ref, 1)

	## Populate data
	print "=> Adding new documents"
	for key, group in recursion.group_list.iteritems():

		if "is_group" in group and group["is_group"] == True:
			parse_and_save_group_object(group)


	## Save current status
	print "=> Saving data"
	# print original_data
	# saveConfig(original_data, "history/old")






