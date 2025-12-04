function TEP = impulse_method(N, K, trellis, R, Eb_N0, d0, d1)

v = zeros(1, K);
x_u = zeros(1, K);
y = ones( 1, N*K);

for l = 1:K
    A = d0 - 0.5;
    x_u_est = x_u;

    while all(x_u_est == x_u) && (A <= d1) %Tant que le decodage de viterbi de creer pas d'erreur 
        A = A+1;
        y(:) = 1; %Remise a 1 de touts les composantes du vecteur
        y(2*l-1) = 1-A; %2*l +1 car nos codes ont un rendement de 1/2

        %Decodage
        x_u_est_ferm = viterbi_decode(y, trellis);

        %Probleme avec la taille de x_u_est_ferm
        %Pas trouvé la solution donc genéré avec ia
        %Debut
        len_est = length(x_u_est_ferm);
        if len_est >= K
            x_u_est = x_u_est_ferm(1:K);
        else
            x_u_est = [x_u_est_ferm, zeros(1, K - len_est)];
        end
        %Fin
    end
    v(l) = floor(A);
end

D = unique(v);
TEP = 0;

for d = D
    Ad = sum(v == d);
    TEP = TEP + Ad*erfc(sqrt(d*R*Eb_N0));
end
TEP = TEP/2;
end