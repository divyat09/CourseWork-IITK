import glob
import os

images = glob.glob("/home/divyat/Desktop/Machine_Learning_Project/SFEW_2/Test/Test_Aligned_Faces/*.png") #Put the address of the folder in which images are
i=1
for image in images:
	with open('input_'+str( i/10 + 1 )+'.txt', 'a') as output_file:
		output_file.write(image+ " 1:10\n")
	i=i+1	
	
