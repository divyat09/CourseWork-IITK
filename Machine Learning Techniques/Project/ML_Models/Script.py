import json
import numpy
import scipy.io as sio

for I in range(1,2):
	filename = 'features_'+str(I)+'.json'
	total_features=[]

	with open(filename) as data_file:
		data = json.load(data_file)

	for i in range(0,len(data['responses'])):

		feature_list=[]

		sub_data=data['responses'][i]
		if 'faceAnnotations' in sub_data.keys():

			list_data=sub_data['faceAnnotations'][0]

			for item in list_data['landmarks']:

				feature_type=item['type']
				y_coordinate=item['position']['y']
				x_coordinate=item['position']['x']
				z_coordinate=item['position']['z']

				feature_list.append(x_coordinate)
				feature_list.append(y_coordinate)
				feature_list.append(z_coordinate)

			total_features.append(feature_list)

	Matrix=numpy.zeros((len(total_features),len(total_features[0])))

	i=0
	j=0

	for item in total_features:
		j=0
		for sub_item in item:
			Matrix[i][j]=sub_item
			j=j+1
		i=i+1
		print j

	sio.savemat('/home/divyat/Desktop/Merged/file_'+str(I),mdict={'Matrix':Matrix} )
