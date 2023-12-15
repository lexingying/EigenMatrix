%X unit disk

rng(17);

if(1)
    %generate sampling points
    nz = 40;
    rs = rand(nz,1) + 1.2; % a bit away
    as = rand(nz,1)* 2*pi;
    zs = rs.* exp(i*as);     zs = zs(:);
    
    %function
    gfn = @(t,s) 1./(t*ones(size(s.'))-ones(size(t))*s.');
    
    %get M
    EPS=STD;
    ng = 1024;    gs = exp(2*pi*i*[1/2:ng]'/ng);         T = gfn(zs,gs);
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
        %generate x
        %nx = 4;        %tmp = (2*rand(100)-1) + i*(2*rand(100)-1);         gud = find(abs(tmp)<0.99);        xs = tmp(gud(1:nx));
        %ws = (1 + rand(size(xs)))/2;
        
        %prepare u
        us = gfn(zs,xs)*ws;
        us = us .* (1+STD*(randn(nz,1) + i*randn(nz,1)));
        
        %recover
        na = nx+1;
        A = zeros(numel(zs),na);
        A(:,1) = us;
        for g=1:na-1
            A(:,g+1) = M*A(:,g);
        end
        [tU,tS,tV] = svd(A,'econ');
        p = tV(:,end);
        rts = roots(p(end:-1:1));            %cut            rts
        bad = find(abs(rts)>1); rts(bad) = rts(bad)./abs(rts(bad));                %if(numel(rts)<2) pause; end;
        
        %get solution
        xa = rts;
        wa = gfn(zs,xa)\us;
        
        %postprocessing
        fun = @(y) sum(abs(gfn(zs, y([1:nx])+i*y(nx+[1:nx]))*(y(2*nx+[1:nx])+i*y(3*nx+[1:nx]))-us).^2);        options = optimoptions(@fminunc,'Display','off');
        [y,fval] = fminunc (fun, [real(xa);imag(xa);real(wa);imag(wa)]);
        xb = y(     [1:nx])+i*y(  nx+[1:nx]);
        wb = y(2*nx+[1:nx])+i*y(3*nx+[1:nx]);
                
        %check
        vb = gfn(zs,xb)*wb; %app
        vs = gfn(zs,xs)*ws; %ext
        relerr = norm(vb-vs)/norm(vs);
    end
end
