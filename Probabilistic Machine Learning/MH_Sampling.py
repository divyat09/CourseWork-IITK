import numpy as np
import random
import math
import matplotlib.pyplot as plt

# Function to compute the Normal Distribution
def Normal(z, mean, cov):
    t1 = np.transpose( z - mean )
    t2 = np.linalg.inv( cov )
    t3 = z- mean
    Determinant = np.sqrt( np.linalg.det( cov ) )

    return  np.exp( -1* np.dot( np.dot(t1,t2), t3 ) ) / ( Determinant * (2*pi) )

# Defining the Global parameters for the problem
pi = math.pi
SigmaList = [ 0.01, 1, 100  ]
SampleList = [ 10**2, 10**3, 10**4 ]

# Main Code:
for TotalSamples in SampleList:
    for ProposalSigmaSq in SigmaList:

        # To store the generated samples list
        GeneratedSamples = []
        # Keep count of total iterations
        Total_Iters = 0

        # Defining the p Distribution....the one from which we originally need to draw samples
        p_mean = np.array([4,4])
        p_cov = np.array([[1,0.8],[0.8,1]])

        # Defining the Proposal Distribution, the one from which we willdraw samples
        PrevSample = np.array([random.random(), random.random()]) # This is z(t) which serves as mean of q for sampling z(t+1)
        q_mean = q_cov = np.array([[ProposalSigmaSq, 0],[0, ProposalSigmaSq]])

        # Generating the Samples
        while( len(GeneratedSamples) < TotalSamples):

            CurrentSample = np.random.multivariate_normal( PrevSample, q_cov)

            # Computing the densities required for Acceptance Probablity
            P_Density_Curr = Normal( CurrentSample , p_mean, p_cov )
            P_Density_Prev = Normal( PrevSample, p_mean, p_cov )
            Q_Density_Curr = Normal( CurrentSample, PrevSample, q_cov )
            Q_Density_Prev = Normal( PrevSample, CurrentSample, q_cov )

            AcceptanceProb = min( 1, ( P_Density_Curr * Q_Density_Prev ) / ( P_Density_Prev * Q_Density_Curr  ) )

            if random.random() < AcceptanceProb:
                GeneratedSamples.append( CurrentSample )
                PrevSample = CurrentSample

            Total_Iters = Total_Iters + 1

        # Plotting
        GeneratedSamples  = np.array( GeneratedSamples )
        plt.title("Total Samples = "+str(TotalSamples) + " Sigma = " +str(ProposalSigmaSq) )
        plt.plot( GeneratedSamples[:,0] , GeneratedSamples[:,1] , '.' )
        plt.show()

        # Calcualting Rejection Rate
        AcceptedSamples =  len( GeneratedSamples)
        RejectionRate  = 1 - ( float(AcceptedSamples)/ Total_Iters )

        print AcceptedSamples,
        print "\t",
        print ProposalSigmaSq,
        print "\t",
        print RejectionRate,
        print "\n"
