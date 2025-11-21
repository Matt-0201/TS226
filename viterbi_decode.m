function c = viterbi_decode(y, trellis)
        
    L = length(y);
    taille_y = log2(trellis.numOutputSymbols);
    nb_etapes = L / taille_y;
    metrics = inf(trellis.numStates, L + 1);
    prec = inf(trellis.numStates, L + 1);
    ns = log2(trellis.numOutputSymbols);
    metrics(1,1) = 0;
    prec(1,1) = 0;
    for t=1:nb_etapes
        extrait_y = y((t-1)*taille_y+1:(t-1)*taille_y+1+taille_y-1);  % C'est le bout de y que l'on va utiliser pour notre produit scalaire
        for etat=1:trellis.numStates
            % On vérifie si le point a déjà été calculé
            if (metrics(etat, t) ~= inf)
                all_next_states = trellis.nextStates(etat,:);
                disp(all_next_states);
                for bit_received=1:length(all_next_states)
                    next_state = all_next_states(bit_received);
                    output = trellis.outputs(next_state+1, bit_received);
                    disp(int2bit(output, 2));
                    %bits = int2bit(trellis.outputs(etat, :), ns);
                    %disp(bits);
                    %metric = dot(extrait_y, de2bi(etat_suivant,2));
                    %disp(metric)
            
                end
        
            end
    
        end
    end
end