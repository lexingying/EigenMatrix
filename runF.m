L = 10;
if(1)
    nz = 128;
    %hs = sort(rand(nz/2,1) * L);
    %hs = linspace(0,L,nz/2)';    zs = [hs; -hs];
    %zs = linspace(-L,L,nz)';
    %hs = sort(rand(nz/2,1) * L);zs = [-hs(end:-1:1);hs];
    zs  = sort(rand(nz,1)*2*L-L);
    
    %function
    gfn = @(t,s) exp(i*pi*t*transpose(s));
    
    %get M
    EPS = STD;
    ng = 1023;    gs = sort(cos(pi*[0:ng]'/ng));;         T = gfn(zs,gs);
    for g=1:size(T,2);        T(:,g) = T(:,g)/norm(T(:,g));    end
    if(0)
        [Q,R,ord] = qr(T,0);    gud = find(abs(diag(R))>EPS*abs(R(1)));    idx = ord(gud);
        ss = gs(idx);    S = T(:,idx); %S: skeleton
        M = S * diag(ss)*pinv(S);
    else
        M = T * diag(gs)*pinv(T,EPS);
    end
    fprintf(1, 'MT-TD error: %d\n', norm(M*T-T*diag(gs))/norm(M*T));
    %tmp = M*T; aux=zeros(size(gs)); for a=1:size(T,2) aux(a) = T(:,a)\tmp(:,a); end;  plot(abs(aux./gs))
    
    %run tests
    if(1)
        %prepare u
        usext = gfn(zs,xs)*ws;
        us = usext .* (1+STD*(randn(nz,1) + i*randn(nz,1)));
        
        %recover
        na = nx+1;
        A = zeros(numel(zs),na);
        A(:,1) = us;
        for g=1:na-1
            A(:,g+1) = M*A(:,g);
        end
        sv = svd(A,'econ'); %sv'
        [tU,tS,tV] = svd(A(),'econ');
        p = tV(:,end); p=p/p(end); p=real(p);
        rts = roots(p(end:-1:1));
        rts = real(rts);        bad = find(abs(rts)>1); rts(bad) = rts(bad)./abs(rts(bad));
        
        %get solution
        xa = sort(rts);        %tmp = gfn(zs,xa);        %wa = [real(tmp);imag(tmp)]\[real(us);imag(us)];
        wa = real(gfn(zs,xa)\us);        %figure(4); hold on; stem(xs, ws, 'b');        stem(xa, wa, 's');
        
        %postprocessing
        fun = @(y) sum(abs(gfn(zs,y(1:end/2))*y(end/2+1:end) - us).^2);        options = optimoptions(@fminunc,'Display','off');
        [y,fval] = fminunc (fun, [xa;wa]);
        xb = y(1:end/2);
        wb = y(end/2+1:end);
        
        %check
        vb = gfn(zs,xb)*wb; %app
        vs = gfn(zs,xs)*ws; %ext
        relerr = norm(vb-vs)/norm(vs);
        %if(numel(rts)<4) pause; end;
    end
end
