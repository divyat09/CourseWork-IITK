% This function solves AX=B by Gauss Elimination/LU Decomposition

function f= Linear_System_Solution(L, U, P, B, N)
	
	X= zeros(N,1);	% Solution of AX=B	
	Y= zeros(N,1);	
	Perm_B= zeros(N,1);

	% Permuting the matrix B
	for n=1:N
		Perm_B(n)= B(P(n));
	end

	% Solving L*Y=B
	temp=0;
	Y(1)= Perm_B(1);
	for n=2:N
		for m=1:n-1
			temp = temp + L(n,m)*Y(m); 	
		end
		Y(n)= Perm_B(n) - temp;
		temp=0;
	end

	% Solving U*X= Y
	temp=0;
	X(N)= Y(N)/U(N,N);
	for n=1:N-1
		for m=N-n+1:N
			temp = temp + U(N-n,m)*X(m); 	
		end
		X(N-n)= ( Y(N-n)-temp )/U(N-n, N-n);
		temp=0;
	end

	f= X;
end
