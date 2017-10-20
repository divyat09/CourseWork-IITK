function f=approxFunction(xEval, xGrid, fGrid, a, b)
	
	[x N] = size(xGrid);
	N = N-1;
	[x N_Test] = size(xEval);

	Interpolation_Matrix= zeros(N+1,N+1);
	p= zeros(N+1);
	p(1)=2;
	p(N+1)=2;
	p(2:N)=1;
		
	% Calculating the Interpolation_Matrix I(j,k) = 2cos(k*j*pi/N)/(p(j)*p(k)*N) 
	Interpolation_Matrix= bsxfun( @(j,k) (2*cos(k*j*pi/N))./( p(j+1)*p(k+1)*N) ,0:N, transpose((0:N)));
	
	% We calculate the coffecients of polynomial as Coffecients(j)= summation_over_k( I(j,k)*fGrid(k))
	coffecients = Interpolation_Matrix*transpose(fGrid);

	% We need to create the Chebyshev Basis as T(j,k)= cos(j*acos(( 2*xEval(k)-(b+a)) / (b-a) ))
	% Then, final approximated polynomial evaluated over point xEval(k) is f = sum_over_j coffecients(j)*T(j,k) 
	% Now, k varies as 1:N_Test. So, we need to evaluate approximated polynomial f for k=1:N_Test points
	% Result is f(xEval([1:N_Test])) which is contained in fApprox_Eva
	
	% To achieve the result f(xEval([1:N_Test])), we first create a meshgrid that would help in finding Basis for all N_Test points
	% We create a Basis matrix such that kth row contains the Chebyshev Basis of our approximated polynomial evaluated for the point xEval(k) 
	
	% Hence, multiplying Basis(kth row) with coffecients gives us value of f evaluated over the point xEval(k)
	% So, Basis*coffecients gives us value of our approximated polynomial over test points xEval(:)
	

	Test= xEval(1:N_Test);
	[ Vec_j, Vec_k]= meshgrid([0:N],Test);
	Basis = cos(Vec_j.*acos( (2*Vec_k -(b+a)) / (b-a) ));

	fApprox_Eval =  Basis*coffecients ;

	f= transpose(fApprox_Eval);
end