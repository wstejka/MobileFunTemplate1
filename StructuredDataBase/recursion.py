import json
from collections import namedtuple
from google.cloud import firestore
from bunch import bunchify
from copy import deepcopy
import uuid

def recursion(array, ident, parent, level, is_group):


	identString = getIdent(ident)
	ident += global_ident
	order = 10

	for item in array:
		id = str(uuid.uuid4())

		itemcopy = deepcopy(item)
		document = bunchify(itemcopy)

		if is_group == True:
			# print getattr(document, 'description')
			print identString, ">", item["name"], "(" + str(level) + ")" , "==>", id, "|", parent, "|", document.imageName

			# Validate there is no "references" and "products" array at the same time
			if reference_field in item and products_field in group_list:
				raise ValueError(reference_field, "and", products_field, "cannot be a part of the node at the same time")

			final = True
			check_is_group = True
			array_for_group = []
			if reference_field in item and len(item[reference_field]) > 0:
				final = False
				array_for_group = item[reference_field]
			else:
				if products_field in item:
					check_is_group = False
					array_for_group = item[products_field]

			# Subgroup
			group_list[id] = {"title" : document.name,
								"shortDescription" : document.shortDescription,
								"longDescription" : document.longDescription if document.longDescription != "" else default_longDescription,
								"imageName" : document.imageName if document.imageName != "" else "".decode("utf-8"),
								"id" : id.decode("utf-8"),
								"parent_id" : parent.decode("utf-8"),
								"final" : final,
								"order" : order,
								"level" : level,
								"is_group" : True}

			recursion(array_for_group, ident, id, level + 1, is_group=check_is_group)
		else:
			# Product
			# print getattr(document, 'description')
			print identString, "<", item["name"], "(" + str(level) + ")" , "==>", parent
			product_list[id] = {
				"title" : document.name,
				"shortDescription" : document.shortDescription,
				"longDescription" : document.longDescription if document.longDescription != "" else default_longDescription,
				"images" : document.images,
				"id" : id.decode("utf-8"),
				"parent_id" : parent.decode("utf-8"),
				"order" : order,
				"level" : level,
				"is_group" : False,
				"quantityInStock" : 0.0,
				"price" : document.price,
				"currency_type" : document.currency_type,
				"specification" : document.specification

			}
		order += 10


def checkMandatoryFields(mandatory_fields, not_empty_fields, group):
	""" """

	isError = False
	for field in mandatory_fields:
		if not field in group:
			isError = True
			print "    <===== ERROR - missing mandatory field =====>", field

	if isError:
		if "title" in group:
			print "    =======>>>>>>> ", group["title"], "<<<<<<======="
		else:
			print group

		raise ValueError('Missing mandatory fields')

	for field in not_empty_fields:
		if field in group and group[field] == "":
			print "    <===== WARNING - missing field or empty =====>", field, "for", group["title"]


	return not isError


def getIdent(len):

	ident = ""
	for x in xrange(1, len):
		ident += " "
	return ident	


reference_field = "references"
products_field = "products"
global_ident = 4
group_list = {}
product_list = {}

default_longDescription = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.".decode("utf-8")


########### MAIN ################	
if __name__ == "__main__":

	file_name = "storeDataStructure.json"
	f = open(file_name, "r")
	output = f.read()
	f.close()
	data = json.loads(output)

	recursion(data, 0, "", 0, is_group=True)

	# for key, group in group_list.iteritems():
	# 	print group["title"]
	# print "Count: ", len(group_list)

	# Check all mandatory field are there
	mandatory_fields = ["title", "order", "level", "final", "id", "shortDescription", "longDescription", "imageName"]
	not_empty_fields = ["shortDescription", "longDescription", "imageName"]
	for key, group in group_list.iteritems():
		
		checkMandatoryFields(mandatory_fields, not_empty_fields, group)







