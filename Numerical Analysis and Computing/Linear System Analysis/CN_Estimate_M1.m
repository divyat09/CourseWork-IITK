% This function calculates the Condition Number using heuristic (a) of Problem 2

function f= CN_Estimate_M1(A,N)

	Y=zeros(N,1);
	Z=zeros(N,1);
	U= zeros(N,N);
	L= zeros(N,N);
	P= zeros(N,1);

	% Calculating vector y here

	list=LU_Decomposition(transpose(A),N);
	L = list(1:N,1:N);
	U = list(1:N,N+1:2*N);
	P = list(1:N,2*N+1);

	Y = Linear_System_Solution_Intermediate(L,U,N);

	% Calculating vector z here

	list=LU_Decomposition(A,N);
	L = list(1:N,1:N);
	U = list(1:N,N+1:2*N);
	P = list(1:N,2*N+1);

	Z = Linear_System_Solution(L,U,P,Y,N);
	
	% Solving for the case of 1 norm

	Y_One_Norm=sum(abs(Y));
	Z_One_Norm=sum(abs(Z));
	One_Norm_Inv_A =  Z_One_Norm/ Y_One_Norm; 
	One_Norm_A= One_Norm(A,N);
	
	One_Norm_CN= One_Norm_A*One_Norm_Inv_A;

	% Solving for the case of infinite norm

	Y_Inf_Norm=max(abs(Y));
	Z_Inf_Norm=max(abs(Z));
	Inf_Norm_Inv_A =  Z_Inf_Norm/ Y_Inf_Norm; 
	Inf_Norm_A= Inf_Norm(A,N);
	
	Inf_Norm_CN= Inf_Norm_A * Inf_Norm_Inv_A;

	f = [ One_Norm_CN Inf_Norm_CN];  
end