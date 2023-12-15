rng(23);

if(1)
    nz = 100;
    zs = (rand(nz,1))*10-5;
    zs = sort(zs(:));
    
    %function Cauchy
    gfn = @(t,s) 1./(1+4*(t-s').^2);
    x2t = @(x) x;
    t2x = @(t) t;
    
    %get M
    EPS = STD;
    ng = 1024;    gs = sort(cos(pi*[0:ng]'/ng));;         T = gfn(zs, t2x(gs)); %LEXING: [0,2] interval
    for g=1:size(T,2);        T(:,g) = T(:,g)/norm(T(:,g));    end
    if(0)
        [Q,R,ord] = qr(T,0);    gud = find(abs(diag(R))>EPS*abs(R(1)));    idx = ord(gud);
        ss = gs(idx);    S = T(:,idx); %S: skeleton
        M = S * diag(ss)*pinv(S);
    else
        M = T * diag(gs)*pinv(T,EPS);
    end
    fprintf(1, 'MT-TD error: %d\n', norm(M*T-T*diag(gs))/norm(M*T));
    
    %run tests
    if(1)
        %prepare u
        us = gfn(zs,xs)*ws;
        us = us .* (1+STD*(randn(nz,1)));
        
        %recover
        na = nx+1;
        A = zeros(numel(zs),na);
        A(:,1) = us;
        for g=1:na-1
            A(:,g+1) = M*A(:,g);
        end
        [tU,tS,tV] = svd(A,'econ');
        p = tV(:,end);
        rts = roots(p(end:-1:1));
        rts = real(rts);        bad = find(abs(rts)>1); rts(bad) = rts(bad)./abs(rts(bad));
        
        %get solution
        xa = sort(t2x(rts));
        wa = real(gfn(zs,xa)\us);        %wa = gfn(zs,xa)\us;        %figure(4); hold on; stem(xs, ws, 'b');        stem(xa, wa, 's');
        
        %postprocessing
        fun = @(y) sum(abs(gfn(zs,y(1:end/2))*y(end/2+1:end) - us).^2);        options = optimoptions(@fminunc,'Display','off');
        [y,fval] = fminunc (fun, [xa;wa]);
        xb = y(1:end/2);
        wb = y(end/2+1:end);

        %check
        vb = gfn(zs,xb)*wb; %app
        vs = gfn(zs,xs)*ws; %ext
        relerr = norm(vb-vs)/norm(vs);
    end
end
