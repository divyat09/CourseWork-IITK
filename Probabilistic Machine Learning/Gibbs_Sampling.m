clear;

% load the data (documents x words matrix, N documents, M words)
load('20newsgroups');

[N M] = size(X);
% hyperparameters of the gamma priors on U,V,Lambda
% these choice of hyperparams leads to an uninformative/vague gamma prior
a_u = 1;b_u = 1e-6;
a_v = 1;b_v = 1e-6;

% number of latent factors
K = 20;

% initialization
U = gamrnd(a_u,1/b_u,N,K); % NxK matrix, drawn randomly from the prior
V = gamrnd(a_v,1/b_v,M,K); % MxK matrix, drawn randomly from the prior

% number of iterations
max_iters = 1000;
burnin = 500;

% prepare the training and test data

[I J vals] = find(X); % all nonzero entries (with indices) in X
% vals is a vector containing denotes the nonzero entries in X
% I and J are vectors with row and column indices resepectively

% Do an 80/20 split of matrix entries (nonzeros) into training and test data
num_elem = length(I);
num_nz = length(J);

rp = randperm(num_elem);

% indices of training set entries
I_train = I(rp(1:round(0.8*num_elem)));
J_train = J(rp(1:round(0.8*num_nz)));

% indices of test set entries
I_test = I(rp(round(0.8*num_elem)+1:end));
J_test = J(rp(round(0.8*num_nz)+1:end));

% values of the training and test entries
vals_train = vals(rp(1:round(0.8*num_nz)));
vals_test = vals(rp(round(0.8*num_nz)+1:end));

% Test and Train length
N_Train= length(I_train);
N_Test= length(I_test);

%Train_Error_List= zeros(N_Train,1);
Test_Error_List_Single= zeros( max_iters ,1);
Test_Error_List_MCAvg= zeros( max_iters -burnin,1);

% Extra variables to be needed

U_MCAvg = zeros(N,K);
V_MCAvg = zeros(M,K);
X_n0 = zeros(N,K);
X_m0 = zeros(M,K);

for iters=1:max_iters

    % run the Gibbs sampler for max_iters iterations
    % in each iteration, draw samples of U, V, lambda
    tic;

    it =1:N_Train;

    n = I_train(it);
    m = J_train(it);

    Size = X(n + N*(m-1));
    Prob = U(n,:).*V(m,:);
    Normalise = sum(Prob, 2);
    Prob= bsxfun(@rdivide, Prob, Normalise(:) );

    Y= mnrnd(Size, Prob);

    X_n = X_n0;
    X_m = X_m0;

    for it=1:N_Train

        n = I_train(it);
        m = J_train(it);

        X_n(n,:) = X_n(n,:) + Y(it,:);
        X_m(m,:) = X_m(m,:) + Y(it,:);

    end

    % Sample U using its local conditional posterior

    k= 1:K;
    b0= 1./( b_u + sum(V(:,k)));
    U= gamrnd( a_u + X_n, repmat(b0, N, 1 ) );

    % Sample V using its local conditional posterior

    k= 1:K;
    b0= 1./( b_v + sum(U(:,k)) );
    V= gamrnd( a_v + X_m, repmat(b0, M, 1 ) );

    % Calculate the reconstructor error (mean absolute error) of trainin and test entries
    % Approach 1 (using current samples of U and V from this iteration)

    P= U*transpose(V);

    it= 1:N_Train;
    n = I_train(it);
    m = J_train(it);
    mae_train = sum( abs( ( X(n + N*(m-1))-P(n +N*(m-1) )) ) )/ N_Train;

    it = 1:N_Test;
    n = I_test(it);
    m = J_test(it);
    mae_test = sum( abs( ( X(n + N*(m-1))-P(n +N*(m-1) ))/ N_Test ) );

    Test_Error_List_Single(iters,1) = mae_test;
    fprintf('Done with iteration %d, MAE_train = %f, MAE_test = %f\n',iters,mae_train,mae_test);


    % Approach 2 (using Monte Carlo averaging; but only using the
    % post-burnin samples of U and V)
    if iters > burnin

        U_MCAvg = U_MCAvg + U;
        V_MCAvg = V_MCAvg + V;
        normalising = (iters - burnin )^2;

        P_MCAvg = U_MCAvg*transpose(V_MCAvg)/normalising;

        it= 1:N_Train;
        n = I_train(it);
        m = J_train(it);
        mae_train_avg = sum( abs( ( X(n + N*(m-1))-P_MCAvg(n +N*(m-1) )) ) )/ N_Train;

        it = 1:N_Test;
        n = I_test(it);
        m = J_test(it);
        mae_test_avg = sum( abs( ( X(n + N*(m-1))-P_MCAvg(n +N*(m-1) ))/ N_Test ) );

        Test_Error_List_MCAvg(iters-burnin,1) = mae_test_avg;
        fprintf('With Posterior Averaging, MAE_train_avg = %f, MAE_test_avg = %f\n', mae_train_avg, mae_test_avg);

    end

    toc;

end

plot([1:max_iters], Test_Error_List_Single, '.');
title('Single Sample');
xlabel('iterations');
ylabel('MAE Test');

figure;
plot([burnin+1:max_iters], Test_Error_List_MCAvg, '.');
title('Monte Carlo Averaging');
xlabel('iterations');
ylabel('MAE Test');

Print the K topics (top 20 words from each topic)
% Take the V matrix and finds the 20 largest entries in each column of V. The function 'printtopics' does it

printtopics(V);
