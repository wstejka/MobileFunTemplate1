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



########### MAIN ################	
if __name__ == "__main__":

	pp = pprint.PrettyPrinter(indent=4)
	client = getFirestoreClient()
	# doc_ref = client.collection('Groups') 



	output = readConfig("storeDataStructure.json")
	data = json.loads(output)
	recursion.recursion(data, 0, "")

	## CLEAR old Groups
	print "Deleting old documents"
	group_ref = firestore.CollectionReference("Groups", client=client)
	delete_collection(group_ref, 1)

	## Populates
	print "Adding new documents"
	for group in recursion.group_list:

		# if "parent_id" in group and group["parent_id"] != "":
		doc_ref = firestore.DocumentReference("Groups", group["id"], client=client)
		# print type(group), group
		doc_ref.set(group)





	# docRef = firestore.DocumentReference("Groups", "test", client=client)
	# docs = doc_ref.get()
	# print type(doc_ref)
	# for doc in docs:
	# 	dict = doc.to_dict()
	# 	print doc.id, "=>", dict
	# 	if "final" in dict and dict["final"] == False:
	# 		# print "BUBA"
	# 		subgroup_ref = doc_ref.document(doc.id).collection("subgroup")
	# 		subdocs = subgroup_ref.get()
	# 		for subdoc in subdocs:
	# 			# print "  ", subdoc.id, " "
	# 			sdict = subdoc.to_dict()
	# 			if "parent" in sdict:
	# 				ref = sdict["parent"]
	# 				print "======>", ref.id, ref.parent.id
	# 				print type(ref)

	# 				ref.set({"ala" : u"kot", "domek" : True, "newRef" : docRef})
	# 		# pp.pprint(sdict)


