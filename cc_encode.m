function c = cc_encode(u, trellis)
    
    K = length(u);
    m = log2(trellis.numStates);
    ns = log2(trellis.numOutputSymbols);
    
    c = [];
    state = 0;
    % Ouverture + section
    for i=1:K
        out = trellis.outputs(state+1, u(i)+1);
        state = trellis.nextStates(state + 1, u(i) + 1);
        outbit = int2bit(out, ns);
        c = [c, outbit'];
    end

    % Fermeture
    for i=1:m
        [nextState, nextBit] = min([trellis.nextStates(state+1, 1), trellis.nextStates(state+1, 2)]);
        out = trellis.outputs(state+1, nextBit);
        disp(out);
        outbit = int2bit(out, ns);
        c = [c, outbit'];
        state = nextState;
    end

end

