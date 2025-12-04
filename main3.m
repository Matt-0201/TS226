
clear
clc

%Paramètres
%Code convutif (1,13/17)
m = 3;
contrainte = m + 1;
polynome = [15, 17];
feedback = 15;

u = [1 1 0 1 0];

% K = 10; %Longueur du vecteur d'information
% u = randi([0,1],K,1);
% u = u'; %Pas forcement utile mais coehérent pour avoir les memes dimensions entree et en sortie
trellis = poly2trellis(contrainte, polynome, feedback);

d = distspec(trellis);



% Codeur
c = cc_encode(u, trellis);

%Canal bruité (BBGC)
y = 1-2*c; %BPSK

% Décodeur
u_ = viterbi_decode(y, trellis);