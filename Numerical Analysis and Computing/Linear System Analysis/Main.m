% Code for Problem 2 
format long

part= input('Enter 1 for the case of A1 matrix and 2 for the case of A2 matrix as given in question ');
N=3;
A= zeros(N,N);
Inv_A= zeros(N,N);

if (part ==1)
	A=[10 -7 0; -3 2 6; 5, -1, 5 ];
else
	A=[-73 78 24; 92, 66, 25; -80, 37, 10];
end

% Code for Part (a) here
% CN_Estimate_M1 computes the condition number by heuristic (a) as given in  Problem 2

Ans=CN_Estimate_M1(A,N);
One_Norm_CN_1 = Ans(1);
Inf_Norm_CN_1 = Ans(2); 

disp('Condition number estimate using part (a)');
disp('For One Norm Case: ');
disp(One_Norm_CN_1);
disp('For Inf Norm Case: ');
disp(Inf_Norm_CN_1);

% Code for Part (b) here
% CN_Estimate_M2 computes the condition number by heuristic (b) as given in  Problem 2

Ans=CN_Estimate_M2(A,N);
One_Norm_CN_2 = Ans(1);
Inf_Norm_CN_2 = Ans(2);

disp('Condition number estimate using part (b)');
disp('For One Norm Case: ');
disp(One_Norm_CN_2);
disp('For Inf Norm Case: ');
disp(Inf_Norm_CN_2);

% Calculating the condition number for case of inverse of matrix A exactly

list=LU_Decomposition(A,N);
L= list(1:N,1:N);
U= list(1:N,N+1:2*N);
P= list(1:N,2*N+1);

% Calculatig inverse of A by solving as Ax1=e1....Axn=en which leads to [x1...xn] as inverse
for n=1:N
	I = eye(N);
	E= I(:,n);
	Inv_A(:,n)=Linear_System_Solution(L,U,P,E,N);
end

One_Norm_Inv_A= One_Norm(Inv_A, N);		% One_Norm calculates one norm of matrix	
One_Norm_A= One_Norm(A,N);				
One_Norm_CN_3= One_Norm_A * One_Norm_Inv_A;

Inf_Norm_Inv_A= Inf_Norm(Inv_A, N); 	% Inf_Norm calculates infinte norm of matrix
Inf_Norm_A= Inf_Norm(A,N);
Inf_Norm_CN_3= Inf_Norm_A * Inf_Norm_Inv_A;

disp('Condition number estimate by computing A inverse');
disp('For One Norm Case: ');
disp(One_Norm_CN_3);
disp('For Inf Norm Case: ');
disp(Inf_Norm_CN_3);

% Comparing condition number with number given by Matlab

One_Norm_CN_4 = cond(A,1);
Inf_Norm_CN_4 = cond(A,inf);

disp('Condition number estimate using cond function in Matlab ');
disp('For One Norm Case: ');
disp(One_Norm_CN_4);
disp('For Inf Norm Case: ');
disp(Inf_Norm_CN_4);