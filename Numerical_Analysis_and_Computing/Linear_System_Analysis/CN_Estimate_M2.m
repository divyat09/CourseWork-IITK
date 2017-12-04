% This function computes the condition number by Heuristic (b) of Problem 2

function f= CN_Estimate_M1(A,N)

	Z=zeros(N,1);
	One_Norm_A= One_Norm(A,N);   % This function computes One norm of a matrix
	Inf_Norm_A= Inf_Norm(A,N);	 % This function computes Inf norm of a matrix
	One_Norm_Inv_A=0;
	Inf_Norm_Inv_A=0;

	% Computing the LU Decomposition 
	list=LU_Decomposition(A,N);
	L = list(1:N,1:N);
	U = list(1:N,N+1:2*N);
	P = list(1:N,2*N+1);

	for i=1:5

		Y = rand(N,1); 						% Generating a random vector
		% Calculating vector z here
		Z = Linear_System_Solution(L,U,P,Y,N);

		% Solving for the case of 1 norm
		Y_One_Norm=sum(abs(Y));
		Z_One_Norm=sum(abs(Z));

		% Taking that Y for which the ratio norm(Z)/norm(Y) is max
		One_Norm_Inv_A =  max( One_Norm_Inv_A, Z_One_Norm/ Y_One_Norm ); 

		% Solving for the case of infinite norm
		Y_Inf_Norm=max(abs(Y));
		Z_Inf_Norm=max(abs(Z));
		
		% Taking that Y for which the ratio norm(Z)/norm(Y) is max
		Inf_Norm_Inv_A =  max( Inf_Norm_Inv_A, Z_Inf_Norm/ Y_Inf_Norm ); 

	end	

	% Computing the Condiion Numbers
	One_Norm_CN= One_Norm_A*One_Norm_Inv_A;
	Inf_Norm_CN= Inf_Norm_A * Inf_Norm_Inv_A;

	f = [ One_Norm_CN Inf_Norm_CN];  
end