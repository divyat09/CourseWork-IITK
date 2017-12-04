function f= Inf_Norm(A,N)
	Inf_Norm_A=0;
	for n=1:N
		sum=0;
		for m=1:N
			sum= sum + abs(A(n,m)); 		% sum holds the summation of values of nth row
		end
		Inf_Norm_A= max(Inf_Norm_A, sum);	% Taking max over all the rows
	end
	f = Inf_Norm_A;
end	