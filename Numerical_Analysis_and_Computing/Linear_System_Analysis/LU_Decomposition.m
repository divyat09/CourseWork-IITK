% This function calculates the LU Decomposition of given matrix

function f = LU_Decomposition( input_matrix, input_size ) 
	A= input_matrix;
	N= input_size;
	U= zeros(N,N);
	L= zeros(N,N);
	P= zeros(N,1);

	% Initialising matrix L
	for n=1:N
		L(n,n)=1;
	end

	% Initialising Permutation P
	for n=1:N
		P(n)=n;
	end

	% Permuting the matrix A 
	[B, max_index]=max(A(1:N,1));
	A([1 max_index],:)= A([max_index 1],:);
	
	% Storing the Permutation Matrix
	P(1)=max_index;
	P(max_index)=1;

	% Computing the LU Decomposition
	for k=1:N	

		U(k,k)= A(k,k);
		for n=k+1:N
			L(n,k)= A(n,k)/ U(k,k);		
			U(k,n)= A(k,n);
		end

		for n=k+1:N
			for m=k+1:N
				A(n,m)= A(n,m) - L(n,k)*U(k,m);	
			end
		end

		% Applying the Permutation P_prime on A and L
		if (k < N)
			[B, max_index]=max(A(k+1:N,k+1));
			max_index= max_index +k;
			A([k+1 max_index],:)= A([max_index k+1],:);
			L([k+1 max_index],k)= L([max_index k+1],k);

			% Storing the Permutation Matrix
			temp1=P(max_index);
			temp2=P(k+1);
			P(k+1)=temp1;
			P(max_index)=temp2;
		end
	end
	f = [L, U, P]; 
end	