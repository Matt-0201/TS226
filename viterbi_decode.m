function c = viterbi_decode(y, trellis)

    %% Paramètres
    L = length(y); % Longueur séquence reçue
    ns = log2(trellis.numOutputSymbols); %Nb de bits de sortie par symboles
    m = log2(trellis.numStates); %Mémoire du code (Nb de bits dans le registe de la mémoire )
    
    %Il faut impérativement que L soit un multiple de taille_y
    nb_etapes = L/ns; %Nombre d'étapes dans le treillis (Longeur du trellis a parcourir pendant le decodage )
    metrics = inf(trellis.numStates, nb_etapes + 1);
    prec = inf(trellis.numStates, nb_etapes + 1); %Initialisation tableau des prédécesseurs
    
    % Initialisation
    c = zeros(1, nb_etapes);
    metrics(1,1) = 0;
    prec(1,1) = 0;

    for t=1:nb_etapes
        extrait_y = y((t-1)*ns+1:(t-1)*ns+ns); %C'est le morceau de y que l'on va utiliser pour notre produit scalaire (y(1:2), ..., y(13:14))

        for etat=1:trellis.numStates    
            %On vérifie si le point a déjà été calculé
            if (metrics(etat, t) ~= inf)
                all_next_states = trellis.nextStates(etat,:); %Recupération de tous les etats suivants possibles
                %disp(all_next_states);
                for bit_received=1:length(all_next_states) % 1 ou 0
                    next_state = all_next_states(bit_received) + 1; %Lié au fait que matlab n'indexe pas à zéro

                    %Récupération de la sortie codée pour cet état et bit d'entrée
                    sortie_entier = trellis.outputs(etat, bit_received); %sortie codée en entier
                    sortie = de2bi(sortie_entier, ns); %conversion en vecteur binaire
                    sortie = flip(sortie); %alignement des bits avec le vecteur reçu

                    %Calcul produit scalaire
                    poids_branche = 0;
                    for j = 1:ns
                        poids_branche = poids_branche + sortie(j) * extrait_y(j);
                    end
                    nv_poids = poids_branche + metrics(etat, t); %Calcul nouvelle métrique

                    if nv_poids < metrics(next_state, t+1)
                        metrics(next_state, t+1) = nv_poids;
                        prec(next_state, t+1) = etat -1;
                    end
                end
            end
        end
    end
    %disp(metrics);
    %% Recupération séquence decodée
    etat = 0; % on suppose que le chemin final se termine à l'état 0
    for parcours_retour = 0:nb_etapes-1
        ante = prec(etat+1, nb_etapes + 1 - parcours_retour);
        for bit_envoye = 1:2
            if trellis.nextStates(ante+1, bit_envoye) == etat
                c(nb_etapes - parcours_retour) = bit_envoye - 1;
                break;
            end
        end
        etat = ante;
    end
    %Suppression de la fermeture
    c = c(1:nb_etapes - m);
end
