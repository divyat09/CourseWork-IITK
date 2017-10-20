% You are only suppose to complete the "TODO" parts and the code should run
% if these parts are correctly implemented
clear all;close all;

load('mnist_big.mat');
[N D] = size(X_train);
[M D]=size(X_test);
Y_train = Y_train + 1;
Y_test = Y_test + 1;
K= max(Y_train);
W = randn(D,max(Y_train));
b = randn(1,max(Y_train));
W_avg = W;
b_avg = b;
k = 0; % number of mistakes (i.e., number of updates)

% Just do a single pass over the training data (our stopping condition will  simply be this)

for n=1:N
    
    % TODO: predict the label for the n-th training example

    temp= X_train(n,:)* W(:,1) + b(1,1);
    y_pred=1;
    for i=2: max(Y_train)
        curr= X_train(n,:)* W(:,i) + b(1,i);
        if  curr> temp
            temp= curr;
            y_pred=i;     
        end    
    end

    if y_pred ~= Y_train(n)
        k = k + 1;

        % TODO: Update W, b    

        W(:,Y_train(n))= W(:,Y_train(n)) + transpose(X_train(n,:));  
        b(1,Y_train(n))= b(1,Y_train(n)) + 1;

        W(:,y_pred)= W(:,y_pred) - transpose(X_train(n,:));    
        b(1,y_pred)= b(1,y_pred) - 1;

        % TODO: Update W_avg, b_avg using Ruppert Polyak Averaging 

        W_avg= W_avg - ( W_avg - W )/k;   
        b_avg= b_avg - ( b_avg - b )/k;

        % TODO: Predict test labels using both W, b  and W_avg, b_avg               

        for m=1:M
            
            temp= X_test(m,:)* W(:,1) + b(1,1);
            y_test_pred(m)=1;

            temp_avg= X_test(m,:)* W_avg(:,1) + b_avg(1,1);
            y_test_pred_avg(m)=1;

            for i=2:K
                curr= X_test(m,:)* W(:,i) + b(1,i);    
                if  curr > temp
                    temp= curr;
                    y_test_pred(m)=i;     
                end

                curr_avg= X_test(m,:)* W_avg(:,i) + b_avg(1,i);
                if  curr_avg > temp_avg
                    temp_avg= curr_avg;
                    y_test_pred_avg(m)=i;     
                end            
            end
        end    
        
        % Computing the accuracy for both normal and average update perceptron

        acc(k) = mean( transpose(Y_test) == y_test_pred);   % test accuracy     
        acc_avg(k) = mean( transpose(Y_test) == y_test_pred_avg); % test accuracy with R-P averaging        
 
       fprintf('Iteration number %d, Update number %d, accuracy = %f, accuracy (with R-P averaging) = %f\n',n,k,acc(k),acc_avg(k));  
    end 

end
plot(1:k,acc(1:k),'r');
title('Plot of accuracy vs number of updates')
xlabel(' Total number of updates');
ylabel(' Accuracy of classifier ');    
hold on;
plot(1:k,acc_avg(1:k),'g');
title('Plot of accuracy vs number of updates')
xlabel(' Total number of updates');
ylabel(' Accuracy of classifier ');    
drawnow;



        