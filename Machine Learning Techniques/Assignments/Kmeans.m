function [mu,z,score] = kmeans(X,K,init)
% input X is N*D data, K is number of clusters desired.  init is either
% 'random' which just chooses K random points to initialize with, or
% 'furthest', which chooses the first point randomly and then uses the
% "furthest point" heuristic.  the output is mu, which is K*D, the
% coordinates of the means, and z, which is N*1, and only integers 1...K
% specifying the cluster associated with each data point.  score is the
% score of the clustering
  
[N D] = size(X);

if K >= N,
  error('kmeans: you are trying to make too many clusters!');
end;

if nargin<3 || strcmp(init, 'random')
  % initialize by choosing K (distinct!) random points: we do this by
  % randomly permuting the examples and then selecting the first K
  perm = randperm(N);
  perm = perm(1:K);
  
  % the centers are given by points
  mu = X(perm, :)
  
  % we leave the assignments unspecified -- they will be computed in the first iteration of K means
  z = zeros(N,1);

elseif strcmp(init, 'furthest')
  % initialize the first center by choosing a point at random; then
  % iteratively choose furthest points as the remaining centers

  %TODO

  % Choosing the first random point 
  perm = randperm(N);
  rand = perm(1);
  mu(1,:)=X(rand,:);
  
  for k=2:K
    
    max_value=0;
    max=0;
    
    % Calculating the point which should be our kth mean 
    for n=1:N
        
      % Removing those cases when the point is actually one of means already present among k-1 means
         
      count=0;
      for z=1:k-1
        if norm(X(n,:)- mu(z,:))==0   
          count=count+1;
        end
      end
      
      if count==0 
        
        % Finding the mean from which nth example is at least distance among k-1 means

        min_value=norm(X(n,:)- mu(1,:));
        min=1;

        for z=2:k-1
          if norm(X(n,:)- mu(z,:)) < min_value  
            min_value=norm(X(n,:)- mu(z,:));
            min=z; 
          end
        end

        % Calculating the maximum over 

        if norm(X(n,:)- mu(min,:)) > max_value
          max_value= norm(X(n,:)- mu(min,:));
          max=n; 
        end
      end

    end
    
    mu(k,:)=X(max,:);

  end

  % again, do not bother initializing z
  z = zeros(N,1);
else
  error('unknown initialization: use "furthest" or "random"');
end;

% begin the iterations.We will run for a maximum of 20, even though we know that things will *eventually* converge.
for iter=1:20,
  % in the first step, we do assignments: each point is assigned to the
  % closest center.  we will judge convergence based on these assignments, so we want to keep track of the previous assignment
  
  oldz = z;
  
  for n=1:N,
    % assign point n to the closest center
    %TODO
    
    temp=norm(X(n,:)- mu(1,:)); 
    z(n)=1;
    for i=2:K
      if norm(X(n,:)- mu(i,:)) < temp
        temp= norm(X(n,:)- mu(i,:));
        z(n)=i;
      end
    end

  end
  
  % check to see if we have converged
  if all(oldz==z)
    break;  % break out of loop
  end
  
  % re-estimate the means
  %TODO
  
  mu=zeros(K,D);
  count=0;

  for i=1:K
    for n=1:N
      if z(n)==i
        count=count+1;
        mu(i,:)=mu(i,:)+ X(n,:);
      end
    end

    mu(i,:)= mu(i,:)/count;
    count=0;
  end

end;

% final: compute the score

score = 0;
for n=1:N,
  % compute the distance between X(n,:) and its associated mean
  score = score + norm(X(n,:) - mu(z(n),:))^2;
end;
