function [Z,U,evals] = PCA(X,K)
  
% X is N*D input data, K is desired number of projection dimensions (assumed
% K<D).  Return values are the projected data Z, which should be N*K, U,
% the D*K projection matrix (the eigenvectors), and evals, which are the
% eigenvalues associated with the dimensions
  
[N D] = size(X);

if K > D,
  error('PCA: you are trying to *increase* the dimension!');
end;

% first, we have to center the data
%TODO

% Calculating the mean
m=0;
for i=1:N
	m=m+X(i,:);
end
m=m/N;

% Centering Data
for i=1:N
	X(i,:)=X(i,:)-m;
end

% next, compute the covariance matrix C of the data
C=(transpose(X)*X)/N;

% compute the top K eigenvalues and eigenvectors of C... 

evals_temp=eigs(C,K);
[U_temp L]= eigs(C,K);

if K<D
	evals=evals_temp;
    U=U_temp;
end

% Reversing the order as we need them in descending order and for K==D we get in ascending order
if K==D
	for i=1:K
		evals(i)=evals_temp(K-i+1);
	end

	for i=1:K
		U(:,i)=U_temp(:,K-i+1);
	end
end

% project the data
Z = X*U;

