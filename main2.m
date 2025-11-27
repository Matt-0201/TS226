
clear
clc

%poly = [7,5], 7;
% Codeur
m = 2;
contrainte = m + 1;
u = [1 1 0 1 0];
trellis = poly2trellis(contrainte, [7,5], 7);

c = cc_encode(u, trellis);

% Décodeur
y = [-1 -1 -1 -1 1 1 -1 1 1 1 -1 1 -1 -1];

u_ = viterbi_decode(y, trellis);