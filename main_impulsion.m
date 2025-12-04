clc; 
clear; 
close all;

%% Paramètres
N = 2;                  
K = 20;
R = 1/2;
d0 = 1;
d1 = 100;
Eb_N0_dB = 0:10;
Eb_N0_lin = 10.^(Eb_N0_dB/10);

%Liste des treillis
trellis_list = {
    poly2trellis(2,[2 3])     
    poly2trellis(3,[5 7])   
    poly2trellis(4,[13 15])   
    poly2trellis(7,[133 171])
    poly2trellis(3,[5 7],7)   
    poly2trellis(4,[13 15],15)
};

trellis_name = {
    '(2 3)_8'
    '(5 7)_8'
    '(13 15)_8'
    '(133 171)_8'
    '(1 5/7)_8'
    '(1 13/15)_8'
};

colors = lines(length(trellis_list));

figure; hold on; grid on;
xlabel('E_b/N_0 (dB)');
ylabel('TEP');
title('Méthode de l''impulsion');
set(gca, 'YScale','log');

%Boucle pour chaque trellis
for t = 1:length(trellis_list)

    trellis = trellis_list{t};
    v = compute_v(N, K, trellis, d0, d1); %Adaptation de la  fonction impulse_methode pour parallaliser l'affichage

    TEP = zeros(1, length(Eb_N0_lin));
    D = unique(v);

    for i = 1:length(Eb_N0_lin)
        EbN0 = Eb_N0_lin(i);

        sum_val = 0;
        for d = D
            Ad = sum(v == d);
            sum_val = sum_val + Ad * erfc(sqrt(d * R * EbN0));
        end
        TEP(i) = sum_val/2;
    end

    semilogy(Eb_N0_dB, TEP, '-o','LineWidth', 1.6, 'Color', colors(t,:),'DisplayName', trellis_name{t});
end

legend('Location','southwest');

%Adaptation de la  fonction impulse_methode pour parallaliser l'affichage
function v = compute_v(N, K, trellis, d0, d1)

v = zeros(1,K);
y = ones(1,K*N);
x_u = zeros(1,K);

for l = 1:K
    A = d0 - 0.5;
    x_u_est = x_u;

    while all(x_u_est == x_u) && (A <= d1)
        A = A + 1;

        y(:) = 1;
        y(2*(l-1)+1) = 1 - A;

        x_est = viterbi_decode(y, trellis);

        if length(x_est) >= K
            x_u_est = x_est(1:K);
        else
            x_u_est = [x_est zeros(1, K-length(x_est))];
        end
    end

    v(l) = floor(A);
end

end



