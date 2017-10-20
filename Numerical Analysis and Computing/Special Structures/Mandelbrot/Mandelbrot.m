A= input('Enter value of parameter A');
N= input('Enter value of parameter N');
n= input('Enter value of parameter n');

h=A/n;

X_Mid= [-(2*n-1)*h/2 :h :(2*n+1)*h/2];   % Set of x coordinate of midpoints of squares
Y_Mid= [h/2 :h :(2*n+1)*h/2 ];		   	 % Set of y coordinate of midpoints of squares 	

X= [-n*h: h: n*h];						 % Set of x-coordinate of bottom-left vertice of squares	
Y= [0: h: n*h];							 % Set of y-coordinate of bottom-left vertice of squares		

[b n] = size(Y_Mid);	
[a m] = size(X_Mid);

M= zeros(n,m);	    						

for i=1:n
	for j=1:m
		
		a = X_Mid(j); 
		b = Y_Mid(i);
		for k=1:N
			
 			if sqrt((a-1)*(a-1) + b*b) < 1/2		% |z_m -1| < 1/2 then insert 1 which means shaded square
				M(i,j)= 1;							
				break;								% Once shaded, no need to update iterations 
			else
				a = a*(a.^2+ b.^2 +1)/(2*(a.^2 +b.^2));		% Updating real part as per Newton Iterates		
				b = b*(a.^2+ b.^2 -1)/(2*(a.^2 +b.^2));		% Updating complex part as per Newton Iterates
			end	
		end
	end
end

% Generate the square grid plot 
figure 
[X_C Y_C]= meshgrid(X,Y);
pcolor(X_C, Y_C, M);