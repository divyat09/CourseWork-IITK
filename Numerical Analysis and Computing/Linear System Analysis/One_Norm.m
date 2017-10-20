function f = One_Norm(A,N)
	One_Norm_A=0;
	for n=1:N
		sum=0;
		for m=1:N
			sum= sum + abs(A(m,n));		% sum holds the summation of abs value of elements in nth column
		end
		One_Norm_A= max(One_Norm_A, sum);  % Taking max over all the columns  
	end
	f = One_Norm_A;
end