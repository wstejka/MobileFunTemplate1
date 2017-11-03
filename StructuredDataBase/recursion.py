import json
from collections import namedtuple
from google.cloud import firestore
from bunch import bunchify
from copy import deepcopy
import uuid

def recursion(array, ident, parent, level):


	identString = getIdent(ident)
	ident += global_ident
	order = 10

	for item in array:
		id = str(uuid.uuid4())

		itemcopy = deepcopy(item)
		if field_name in item:
			itemcopy[field_name] = []
		document = bunchify(itemcopy)

		if field_name in item:
			# print getattr(document, 'description')
			print identString, item["name"], (level), "==>", parent, "|", document.imageName

			# Subgroup
			group_list[id] = {"title" : document.name,
								"shortDescription" : document.shortDescription,
								"longDescription" : document.longDescription if document.longDescription != "" else default_longDescription,
								"imageName" : document.imageName if document.imageName != "" else "".decode("utf-8"),
								"id" : id.decode("utf-8"),
								"parent_id" : str(parent).decode("utf-8"),
								"final" : False if len(item[field_name]) > 0 else True,
								"order" : order,
								"level" : level,
								"is_group" : True}

			recursion(item[field_name], ident, id, level + 1)
		else:
			# Product
			# print getattr(document, 'description')
			print identString, item["name"], (level), "==>", parent
			product_list[id] = {
				"title" : document.name,
				"shortDescription" : document.shortDescription,
				"longDescription" : document.longDescription if document.longDescription != "" else default_longDescription,
				"images" : document.images,
				"id" : id.decode("utf-8"),
				"parent_id" : str(parent).decode("utf-8"),
				"order" : order,
				"level" : level,
				"is_group" : False
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


field_name = "references"
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

	recursion(data, 0, "", 0)

	# Check all mandatory field are there
	mandatory_fields = ["title", "order", "level", "final", "id", "shortDescription", "longDescription", "imageName"]
	not_empty_fields = ["shortDescription", "longDescription", "imageName"]
	for key, group in group_list.iteritems():
		
		checkMandatoryFields(mandatory_fields, not_empty_fields, group)







