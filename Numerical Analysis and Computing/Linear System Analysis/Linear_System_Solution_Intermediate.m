% This is for solving Y in Transpose(A).Y = C

function f= Linear_SVstem_Solution(L, U, N)
	
	Y= zeros(N,1);
	V= zeros(N,1);	

	% Solving Transpose(U)*V =C
	V(1)=1;
	for n=2:N
		temp= L(n,1:n-1)*V(1:n-1);
		if (abs(1 - temp) > abs(-1-temp))    % Assigning +1 or -1 on basis of larger magnitude
			V(n) = 1-temp;
		else
			V(n) = -1-temp;
	end

	% Solving Transpose(L)*Y =V
	Y(N)= V(N)/U(N,N);
	for n=1:N-1
		temp = U(N-n,N-n+1:N)*Y(N-n+1:N);
		Y(N-n)= ( V(N-n)-temp )/U(N-n, N-n);
	end

	f= Y;
end
