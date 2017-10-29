#!/usr/local/bin/python

from google.cloud import firestore
import os, json, pprint
import recursion as recursion


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
	"""Returns habdler to firestore DB """
	user = os.environ["USER"]
	os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = '/Users/' + user + '/Documents/xCode/MYProjects/MobileFunTemplate1/StructuredDataBase/MobileFunStore-fdf9f054b682.json'
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
	recursion.recursion(data, 0, "", 0)

	# Validate data
	# Check all mandatory field are there
	mandatory_fields = ["title", "order", "level", "url", "final", "id", "shortDescription", "longDescription"]
	for key, group in recursion.group_list.iteritems():
		
		recursion.checkMandatoryFields(mandatory_fields, group)

	## Make copy
	original_data = dict(recursion.group_list)

	## CLEAR old Groups
	print "=> Deleting old documents"
	group_ref = firestore.CollectionReference("Groups", client=client)
	delete_collection(group_ref, 1)

	## Populates
	print "=> Adding new documents"
	for key, group in recursion.group_list.iteritems():

		if "is_group" in group and group["is_group"] == True:
			parse_and_save_group_object(group)


	## Save current status
	print "=> Saving data"
	# print original_data
	# saveConfig(original_data, "history/old")






