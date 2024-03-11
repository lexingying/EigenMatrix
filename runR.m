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
    
    %get M    %EPS=STD;
    ng = 32;    gs = exp(2*pi*i*[1/2:ng]'/ng);         T = gfn(zs,gs);
    for g=1:size(T,2);        T(:,g) = T(:,g)/norm(T(:,g));    end
    if(0)
        [Q,R,ord] = qr(T,0);    gud = find(abs(diag(R))>EPS*abs(R(1)));    idx = ord(gud);
        ss = gs(idx);    S = T(:,idx); %S: skeleton
        M = S * diag(ss)*pinv(S);
    else
        %M = T * diag(gs)*pinv(T,EPS);
        M = T * diag(gs)*pinv(T,norm(T,'fro')*1e-4);
    end
    fprintf(1, 'MT-TD error: %d\n', norm(M*T-T*diag(gs))/norm(M*T));   
end

for it=1:2
    if(    it==1)
        nx = 4;
        xs = 0.9 * exp(2*pi*i*[0.2;0.5;0.8;1]);
        ws = ones(size(xs)); %xs = sort(rand(nx,1)*(2*B)-B);        %ws = (1 + rand(size(xs)))/2;
    elseif(it==2)
        nx = 4;
        xs = 0.9 * exp(2*pi*i*[0.2;0.75;0.8;1]);
        ws = ones(size(xs)); %xs = sort(rand(nx,1)*(2*B)-B);        %ws = (1 + rand(size(xs)))/2;
    end
    
    STDS = [1e-2 1e-3 1e-4];
    for is=1:numel(STDS)
        STD = STDS(is);
        %prepare u
        us = gfn(zs,xs)*ws;
        us = us .* (1+STD*(randn(nz,1) + i*randn(nz,1)));
        
        %recover
        na = round(nx*1.5);
        A = zeros(numel(zs),na);
        A(:,1) = us;
        for g=1:na-1
            A(:,g+1) = M*A(:,g);
        end
        [tU,tS,tV] = svd(A,'econ');        tV = tV(:,1:nx);
        Psi = pinv(conj(tV(1:end-1,:)))*conj(tV(2:end,:));
        rts = eig(Psi);
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
        
        FS=18;
        figure; clf; hold on; set(gca,'DefaultLineMarkerSize',10); plot(gs([1:end,1]),'k'); plot(xs, 'b+');        plot(xa, 'g+');    plot(xb, 'r+'); axis equal;
        set(gca, 'FontSize', FS);    bb=get(gca);    set(bb.XLabel, 'FontSize', FS);    set(bb.YLabel, 'FontSize', FS);    set(bb.ZLabel, 'FontSize', FS);    set(bb.Title, 'FontSize', FS);
        filename = sprintf('exR_%i%i',it,is);
        print(gcf, '-depsc', filename);
    end
end
