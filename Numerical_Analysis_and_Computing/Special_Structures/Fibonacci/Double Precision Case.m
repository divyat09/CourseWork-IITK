function main()
	format long;
	x_0=1;
	j=1;
	k=60;
	global help_func;         	%This is for memoisation of recursive function
	help_func= sparse(j+k,k);
	abs_error=zeros(1,k);
	%Calculating the absolute error as rerquired in question
	for i=1:k
		abs_error(i)= abs(rec_func(j,i,x_0) - sin( x_0 + (j-i)*pi/3 ) );
	end
	figure(1);
	plot(1:k,abs_error);
	title('Plot for Error versus K');
	xlabel('K');
	ylabel('Absolute Error');
	
end

% Function for calculating f^a or through recursion
function f= rec_func(j,k,x_0)
	global help_func;
	if k==0
		f = sin( x_0 + j*pi/3 );
    elseif help_func(j,k)~=0
		f= help_func(j,k);
    else
    	help_func(j,k)= rec_func(j,k-1,x_0)- rec_func(j+1,k-1,x_0);
    	f= help_func(j,k);
  end
end
