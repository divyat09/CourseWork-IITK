import numpy as np
import pandas as pd
import math
import matplotlib.pyplot as plt

# Baysian Regression Model
class Bayesian_Regressor():

	# Training the model
	def __init__(self, data, label, k, beta):
		self.x = data
		self.y = label

		# Training the model
		self.posterior_mu = np.dot( np.linalg.inv(np.dot(np.transpose(self.x), self.x) + np.identity(k+1)*(1/beta) ) , np.dot(np.transpose(self.x), self.y) )
		self.posterior_sigma = np.linalg.inv( np.dot(np.transpose(self.x), self.x)*beta + np.identity(k+1) )

	# Prediciting for new samples
	def posterior_mean( self, x ):
		return np.dot( np.transpose(self.posterior_mu), x)

	def posterior_var( self, x ):
		return  1/beta + np.dot( np.dot( np.transpose(x), self.posterior_sigma ), x )

# Generating features from data
def function_phi(x, k):
	
	feature_data = []

	for i in range(0,k+1):
		feature_data.append( x**i )
	
	feature_data = np.transpose( np.array(feature_data) )

	return feature_data

# Main Code

###########################################IMPORTANT###############################################################
########################################### Set the value of k here ###############################################
###########################################IMPORTANT###############################################################

k = 3
beta = 4.0
x = np.array([-2.23, -1.30, -0.42, 0.30, 0.33, 0.52, 0.87, 1.80, 2.74, 3.62])
y = np.array([1.01, 0.69, -0.66, -1.34, -1.75, -0.98, 0.25, 1.57, 1.65, 1.51])
Regression_Model = Bayesian_Regressor( function_phi(x, k), y, k, beta )

x_test = np.linspace( -4, 4, 100)
x_test_feature = function_phi( x_test, k )
y_test_1 = []
y_test_2 = []
y_test_3 = []

# Values generated for plots
for item in x_test_feature:	
	y_test_1.append( Regression_Model.posterior_mean( item ) )
	y_test_2.append( Regression_Model.posterior_mean( item ) + 2*math.sqrt(Regression_Model.posterior_var( item )) )
	y_test_3.append( Regression_Model.posterior_mean( item ) - 2*math.sqrt(Regression_Model.posterior_var( item )) )

# Finding the Marginal Likelihood by finding first Likelihood, Prior and Posterior

pi = math.pi
likelihood = math.exp( ( np.sum(y**2) )*beta*(-0.5) )* (math.sqrt(beta)**10) / ( math.sqrt(2*pi)**10)
prior = 1/(math.sqrt(2*pi)**(k+1))

t1 = np.transpose( Regression_Model.posterior_mu )
t2 = np.linalg.inv( Regression_Model.posterior_sigma )
t3 = Regression_Model.posterior_mu
det = np.linalg.det( Regression_Model.posterior_sigma )

posterior  = math.exp( np.dot( np.dot(t1, t2), t3 )*(-0.5) ) / ( math.sqrt(det) * ( math.sqrt(2*pi)**(k+1)) )

marginal_likelihood = likelihood*prior/posterior
print "Value of Marginal Likelihood"
print marginal_likelihood

# Plotting
plt.plot( x, y, 'o' , x_test, y_test_1, x_test, y_test_2, x_test, y_test_3 )
plt.xlabel( 'Value of x' )
plt.ylabel( 'Value of y' )
plt.show()
