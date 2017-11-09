#!/usr/local/bin/python

from google.cloud import firestore
import os, json, pprint, sys, six
import populateDataBase as handler

directory = os.path.dirname(sys.argv[0])

def add(product, with_parent_id):

	if "parent_id" in product:
		product["parent_id"] = with_parent_id

	return product

########### MAIN ################	
if __name__ == "__main__":


	id = "0987654321".decode("utf-8")
	product = {
		"title" : "Fake Product".decode("utf-8"),
		"shortDescription" : "shortDescription".decode("utf-8"),
		"longDescription" : "Very, very, very long description".decode("utf-8"),
		"images" : ["nikon_dslr_d3400_black_18_55_vr_front--original.png".decode("utf-8"),
				"nikon_dslr_d3400_black_18_55_vr_front_left--original.png".decode("utf-8"),
				"nikon_dslr_d3400_black_18_55_vr_front_top--original.png".decode("utf-8")],
		"id" : id.decode("utf-8"),
		"parent_id" : "",
		"order" : 5,
		"level" : 0,
		"quantityInStock" : 0.0,
		"price" : 123.45,
		"currency_type" : 0,
		"specification" : [	{"Live view" : "Yes".decode("utf-8")},
							{"Stabilization" : "No".decode("utf-8")},
							{"Firmware" : "1.1".decode("utf-8")}]

	}
	#

	client = handler.getFirestoreClient()
	with_parent_id = "c8bb4f3d-cc07-4dff-8f27-3bdc281bd4f2".decode("utf-8")
	product = add(product, with_parent_id=with_parent_id)
	doc_ref = firestore.DocumentReference("Products", id, client=client)

	# add
	doc_ref.set(product)
	# delete
	# doc_ref.delete()


