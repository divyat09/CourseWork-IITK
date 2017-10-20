format long;
tic;

X = @(t) 2*cos(2*pi*t);
Y = @(t) 3*sin(2*pi*t);
dXdt = @(t) -4*pi*sin(2*pi*t);
dYdt = @(t) 6*pi*cos(2*pi*t);
x0=5;
y0=5;
n=10;
func = @(t) ( X(t)-x0 ).*dXdt(t) + ( Y(t)-y0 ).*dYdt(t);
basis = cell(1,n);
init_basis= cell(1,n);
coff = zeros(1,n);
Zeros= zeros(n,1);

for i=1:n
	if i==1
		basis{i} = @(t) (t.*t -t).^(i-1);
	else 
		temp = @(t) 0;
		for j= 0: i-1
			temp = @(t) temp(t) + nchoosek(i-1,j)*nchoosek(i+j-1,j).*((-t).^j);
		end
		basis{i} = @(t) temp(t);
	end
end

toc;

tic;
% Solving the linear system A(i,i) * <basis(i), basis(i)> = <func, basis(i)>
coff= cellfun(@(x) integral(@(t) func(t).*x(t),0,1),basis)./ cellfun(@(x) integral(@(t) x(t).*x(t),0,1),basis);

%{
Basically, above is vectorised version of this....replace basis{i} with general x 	
for i=1:n
	coff{i} = integral(@(t) func(t).*basis{i}(t), -1, 1) / integral( @(t) basis{i}(t).*basis{i}(t), -1, 1);
end
%}

poly= @(t) 0;
for i=1:n
	poly = @(t) coff(i)*basis{i}(t) + poly(t);
end

coff(1:n-1)=coff(1:n-1)/coff(n);
coff(n)=1;

A(:,n-1)=-coff(1:n-1);
A(2:n-1,1:n-2)= eye(n-2);
A(1,1:n-2)= 0;

Zeros= eig(A);

toc;