% Divyat Mahajan, 14227, Mini Project 1

function f = orthoProjectionOnCurve(x0, y0, X, Y, dXdt, dYdt, eps)
		
	distance = @(t) sqrt((X(t) -x0).^2 + (Y(t) -y0).^2 ); 	 % Distance function 
	func = @(t) ( X(t)-x0 ).*dXdt(t) + ( Y(t)-y0 ).*dYdt(t); % The function whose zeros would provide us with local minimas
															 % This is derivative of the distance function				
	N=2;														 
	while ( N <=100 )
		
		% Intializing variables so that values from previous iteration of loop are overwritten
		M=2*N;
		init_points = zeros(1,N+1);
		points = zeros(1,N+1);
		Interpolation_Matrix = zeros(N+1, N+1);
		coffecients= zeros(N+1,1);
		
		init_points_2 = zeros(1,M+1);
		points_2 = zeros(1,M+1);
		Interpolation_Matrix_2 = zeros(M+1, M+1);
		coffecients_2= zeros(M+1,1);

		% Choosing N+1 points in space as x_k= 0.5*cos(pi*x/N) +0.5 		
		init_points = 0.5*cos(pi*[0:N]/N) + 0.5;
		
		% Computing value of function whose root is to be found over above N+1 points i.e. f(x_k)
		points= func(init_points);
		
		% Generating rule that if j== 0 or N then 2 else 1 which would be required for computing Interpolation_Matrix			
		p= zeros(N+1);
		p(1)=2;
		p(N+1)=2;
		p(2:N)=1;
		
		% Calculating the Interpolation_Matrix I(j,k) = 2cos(k*j*pi/N)/(p(j)*p(k)*N) 
		Interpolation_Matrix= bsxfun( @(j,k) (2*cos(k*j*pi/N))./( p(j+1)*p(k+1)*N) ,0:N, transpose((0:N)));

		% We calculate the coffecients of polynomial as Coffecients(j)= summation_over_k( I(j,k)*f(k))
		coffecients = Interpolation_Matrix*transpose(points)

		% Choosing M+1 points in space as x_k= 0.5*cos(pi*k/N) +0.5 where k=0:N 		
		init_points_2 = 0.5*cos(pi*[0:M]/M) + 0.5;

		% Computing value of function whose root is to be found over above M+1 points i.e. f(x_k)		
		points_2= func(init_points_2);

		% Generating rule that if j== 0 or M then 2 else 1 which would be required for computing Interpolation_Matrix			
		p= zeros(M+1);
		p(1)=2;
		p(M+1)=2;
		p(2:M)=1;
		
		% Calculating the Interpolation_Matrix I(j,k) = 2cos(k*j*pi/M)/(p(j)*p(k)*M) 		
		Interpolation_Matrix_2= bsxfun( @(j,k) (2*cos(k*j*pi/M))./(p(j+1)*p(k+1)*M) ,0:M, transpose((0:M)));

		% Coffecients(j) = summation_over_k( I(j,k)*f(k))
		coffecients_2 = Interpolation_Matrix_2*transpose(points_2);
		
		% Calculating error as norm of difference betwen coffecients of M degree polynomial with N degree polynomial
		x= norm( coffecients_2(1:N+1)-coffecients(1:N+1),1 ) + norm(coffecients_2(N+2:M+1),1);

		% If error is less than eps then we have found a good approximation
		if or(x < eps, M>100)		
			break;
		else
			N=2*N;   	% Updating N as 2*N because we already have calculated error for 2*N=M case earlier, so no point in doing again for less than 2*N
		end

	end	

	% Forming the Companion Matrix that would find the roots of the polynomial approximation for function
	A = zeros(N,N);
	A(1,:)= [1:N] == 2;
	A(N,:)= transpose(-0.5*coffecients(1:N)./coffecients(N+1)) + 0.5*([1:N] == N-1);
	A(2:N-1,:)=bsxfun(@(k,j) 0.5*( (j == k+1) + (j==k-1) ), 1:N, transpose(2:N-1) );

	% Eigenvalues of Companion Matrix would be the roots, but we need to normalize them for interval (0,1)
	V= eig(A); 
	
	% Normalizing the Eigenvalues
	correct_vals  = (arrayfun(@(x) ~any(imag(x)),V)).*V;           
	range = nonzeros((arrayfun(@(x) abs(x)<=1.001, correct_vals)).*correct_vals);
	roots = sort( (range.*0.5) + 0.5 );

	% Finding the least among the roots or local minimas of distance function
	[min_value min_index] = min(distance(roots));	

	% Comparing the least value among local minimas with the boundary value at t=0
	if min_value == min(min_value, distance(0))		
		min_point= roots(min_index);
	else
		min_point= 0;
	end
	
	f= min_point;
end