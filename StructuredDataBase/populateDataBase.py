#!/usr/local/bin/python

from google.cloud import firestore
import os, json, pprint
import recursion as recursion


def readConfig(file_name):
	
	f = open(file_name, "r")
	output = f.read()
	f.close()
	return output


def getFirestoreClient():
	"""Returns habdler to firestore DB """
	user = os.environ["USER"]
	os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = '/Users/' + user + '/Documents/xCode/MYProjects/MobileFunTemplate1/StructuredDataBase/MobileFunStore-fdf9f054b682.json'
	return firestore.Client()

def delete_collection(coll_ref, batch_size):

    docs = coll_ref.limit(10).get()
    deleted = 0

    for doc in docs:
        print(u'Deleting doc {} => {}'.format(doc.id, doc.to_dict()["title"]))
        doc.reference.delete()
        deleted = deleted + 1

    if deleted >= batch_size:
        return delete_collection(coll_ref, batch_size)	

def parse_group_object(group):
	pass


########### MAIN ################	
if __name__ == "__main__":

	pp = pprint.PrettyPrinter(indent=4)
	client = getFirestoreClient()
	# doc_ref = client.collection('Groups') 



	output = readConfig("storeDataStructure.json")
	data = json.loads(output)
	recursion.recursion(data, 0, "", 0)

	## CLEAR old Groups
	print "Deleting old documents"
	group_ref = firestore.CollectionReference("Groups", client=client)
	delete_collection(group_ref, 1)

	## Populates
	print "Adding new documents"
	for group in recursion.group_list:

		doc_ref = firestore.DocumentReference("Groups", group["id"], client=client)
		if "parent_id" in group and group["parent_id"] != "":
			parent = firestore.DocumentReference("Groups", group["parent_id"], client=client)
			group["parent_ref"] = parent

		# decode string to unicode
		group["parent_id"] = (group["parent_id"]).decode("utf-8")
			
		# remove uneeded data from dict
		del group["id"]
		del group["is_group"]
		# del group["parent_id"]
		# print type(group), group
		doc_ref.set(group)



