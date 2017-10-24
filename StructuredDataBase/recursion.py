import json
from collections import namedtuple
from google.cloud import firestore
from bunch import bunchify
from copy import deepcopy
import uuid

group_list = []

def recursion(array, ident, parent, level):


	identString = getIdent(ident)
	ident += global_ident
	order = 10

	for item in array:
		id = uuid.uuid4()
		print identString, item["name"], (level), "==>", parent

		itemcopy = deepcopy(item)
		if field_name in item:
			itemcopy[field_name] = []
		document = bunchify(itemcopy)
		# print getattr(document, 'description')

		if field_name in item:
			# Subgroup
			final = False if len(item[field_name]) > 0 else True
			level
			group_list.append({"title" : document.name,
								"description" : document.description,
								"url" : document.url,
								"id" : str(id),
								"parent_id" : str(parent),
								"final" : final,
								"order" : order,
								"level" : level,
								"is_group" : True})

			recursion(item[field_name], ident, id, level + 1)
		else:
			# Product
			pass
		order += 10


def getIdent(len):

	ident = ""
	for x in xrange(1, len):
		ident += " "
	return ident	


field_name = "references"
global_ident = 4


########### MAIN ################	
if __name__ == "__main__":

	file_name = "test.json"
	f = open(file_name, "r")
	output = f.read()
	f.close()
	data = json.loads(output)

	recursion(data, 0, "", 0)





