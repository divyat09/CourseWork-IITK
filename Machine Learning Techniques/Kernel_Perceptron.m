clear all;close all;
load('mnist_binary.mat');
[N D] = size(X);
% split the data equally into training and test
rp = randperm(N);
X_train = X(rp(1:round(N/2)),:);
X_test = X(rp(round(N/2)+1:end),:);
Y_train = Y(rp(1:round(N/2)),:);
Y_test = Y(rp(round(N/2)+1:end),:);
N_train = size(X_train,1);
N_test = size(X_test,1);

% we will try polynomial kernels with degrees 1,2,4,8,10,20 (note that
% degree = 1 is equivalent to a linear kernel)
d = [1 2 4 8 10 20];
colors = ['r' 'g' 'b' 'm' 'k' 'c'];

% Try kernel Perceptron with each of the 6 polynomial kernels
for num_run=1:6
    % construct the polynomial kernel matrices
    K_trtr = kernelPoly(X_train,X_train,d(num_run));  % train-train kernel matrix
    K_trte = kernelPoly(X_train,X_test,d(num_run));  % train-test kernel matrix

    alpha = zeros(N_train,1); % the Nx1 vector of alpha variables
    alpha_avg = alpha; % we will do RP-averaging

    num_mist(num_run) = 0;
    
    % Train the kernel Perceptron for this choice of kernel (do 10 passes
    % over the training data)
    for pass=1:10
        for n=1:N_train
            
            % TODO: predict the label of test example n
            y_pred=sign( sum(alpha.*Y_train.*K_trtr(:,n)) );
            
            % update if made a mistake
            if y_pred ~= Y_train(n)
                
                % TODO: update the alphas
                alpha(n) = alpha(n) + 1;
                
                % we will do RP-averaging too
                num_mist(num_run) = num_mist(num_run) + 1;
                alpha_avg = alpha_avg - (1/num_mist(num_run))*(alpha_avg - alpha);

                % TODO: predict labels of test data

                for t=1:N_test
                    y_test_pred(t,1)= sign( sum(alpha_avg.*Y_train.*K_trte(:,t)) );
                end
                    
                % compute accuracy
                acc{num_run}(num_mist(num_run)) = mean(Y_test==y_test_pred);        
                fprintf('Polynomial kernel degree = %d, update number %d, test accuracy = %f\n',d(num_run), num_mist(num_run),acc{num_run}(num_mist(num_run)));
                % Note: if you want, you may take the plotting part out of the "pass" loop to
                % make the code run faster
                plot(1:num_mist(num_run),acc{num_run}(1:num_mist(num_run)),colors(num_run)); 
                xlabel('number of mistakes')
                ylabel('accuracy')
                drawnow;        
            end
        end
    end
    hold on;
end
        