from matplotlib import pyplot as plt
from sklearn import svm
import scipy.io as sio
import numpy as np 
import math 

Angry_train=sio.loadmat('/home/divyat/Desktop/Project/Merged_train/Angry.mat')['X']
Disgust_train=sio.loadmat('/home/divyat/Desktop/Project/Merged_train/Disgust.mat')['X']
Fear_train=sio.loadmat('/home/divyat/Desktop/Project/Merged_train/Fear.mat')['X']
Happy_train=sio.loadmat('/home/divyat/Desktop/Project/Merged_train/Happy.mat')['X']
Neutral_train=sio.loadmat('/home/divyat/Desktop/Project/Merged_train/Neutral.mat')['X']
Sad_train=sio.loadmat('/home/divyat/Desktop/Project/Merged_train/Sad.mat')['X']
Surprise_train=sio.loadmat('/home/divyat/Desktop/Project/Merged_train/Surprise.mat')['X']

Angry_test=sio.loadmat('/home/divyat/Desktop/Project/Merged_test/Angry.mat')['X']
Disgust_test=sio.loadmat('/home/divyat/Desktop/Project/Merged_test/Disgust.mat')['X']
Fear_test=sio.loadmat('/home/divyat/Desktop/Project/Merged_test/Fear.mat')['X']
Happy_test=sio.loadmat('/home/divyat/Desktop/Project/Merged_test/Happy.mat')['X']
Neutral_test=sio.loadmat('/home/divyat/Desktop/Project/Merged_test/Neutral.mat')['X']
Sad_test=sio.loadmat('/home/divyat/Desktop/Project/Merged_test/Sad.mat')['X']
Surprise_test=sio.loadmat('/home/divyat/Desktop/Project/Merged_test/Surprise.mat')['X']

#test=sio.loadmat('/home/divyat/Desktop/Project/Train_on_google_api/file_1.mat')

#print type(test)

Emotion_train=[Happy_train, Angry_train , Disgust_train, Fear_train, Neutral_train , Sad_train, Surprise_train]
Emotion_test=[ Happy_test, Angry_test , Disgust_test, Fear_test, Neutral_test , Sad_test, Surprise_test]

Train_Data=Emotion_train[0] #Test data MxD form....D=number of features
[M,N]=Train_Data.shape
y=np.zeros(M)		#True labels of the training data
print M

i=1
while(i<7):
	Train_Data_temp=Emotion_train[i]
	[M,N]=Train_Data_temp.shape
	print M
	y_temp=i*np.ones(M)
	y=np.concatenate((y, y_temp), axis=0)
	Train_Data=np.concatenate((Train_Data, Train_Data_temp), axis=0)
	i=i+1


degree_kernel=[1, 2, 3, 4]
C_parameter=[0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4.0, 4.5, 5.0, 5.5, 6.0, 6.5, 7.0, 7.5, 8.0, 8.5, 9.0, 9.5, 10]
gamma_parameter=[0.2, 0.4, 0.6, 0.8, 1.0, 1.2, 1.4, 1.6, 1.8, 2.0]
accuracy=[]
for i in range(1,5):
	accuracy.append(0)

accuracy_weight=[0, 0 ,0 ,0 ]

for I in range(0,4):	
	#Reweighting with RBF	
	#clf=svm.SVC(C=3.0,class_weight={0:1,1:1,2:5,3:4,4:1,5:1,6:2},kernel='rbf',gamma=math.exp(-8))

	#No Reweighting with RBF	
	#clf=svm.SVC(C=3.0, kernel='rbf',gamma=math.exp(-8))

	#Reweighting with Polynomial	
	#clf_weight=svm.SVC(C=3.0,class_weight={0:1,1:1,2:5,3:4,4:1,5:1,6:2},kernel='poly',degree=degree_kernel[I])

	#No Reweighting with Polynomial	
	clf=svm.SVC(C=3.0,kernel='poly',degree=degree_kernel[I])

	clf.fit(Train_Data,np.transpose(y))
	print clf

	#clf_weight.fit(Train_Data,np.transpose(y))
	#print clf_weight

	i=0
	N_test=0
	count=0
	while(i<7):
		
		[M,N]=Emotion_test[i].shape
		N_test=N_test+M
		y_predicted=clf.predict(Emotion_test[i])
		print y_predicted
		count=count+(y_predicted==i*np.ones(M)).sum()
		i=i+1

	accuracy[I]=count*100.0/N_test
	print(accuracy[I])

'''
	i=0
	N_test=0
	count=0
	while(i<7):
		
		[M,N]=Emotion_test[i].shape
		N_test=N_test+M
		y_predicted=clf_weight.predict(Emotion_test[i])
		print y_predicted
		count=count+(y_predicted==i*np.ones(M)).sum()
		i=i+1

	accuracy_weight[I]=count*100.0/N_test
	print(accuracy_weight[I])
'''

plt.plot(degree_kernel, accuracy, 'r')
#plt.plot(degree_kernel, accuracy_weight, 'b')
plt.xlabel('Degree of Kernel')
plt.ylabel('Accuracy')
plt.show()
