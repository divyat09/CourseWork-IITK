function [xGrid, fGrid] = discreteData(nGrid, a, b, func)
	
	N= nGrid -1;

	% Choosing nGrid points in space as x_k= 0.5*cos(pi*x/N) +0.5 where k=0:N
	% Now, the point x_k is from [0,1] ... so to get the grid in range [a,b] we multiply as a +(b-a)*x_k
	Grid = a + (b-a)*( 0.5*cos(pi.*[0:N]/N) + 0.5 );

	% Computing value of function over above nGrid points i.e. f(x_k)
	func_Grid= func(Grid);

	xGrid= Grid;
	fGrid= func_Grid;

end