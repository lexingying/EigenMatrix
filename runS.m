if(1)
    beta = 100;
    nz = 256;
    hf = nz/2;
    hs = pi/beta * [1:2:(2*hf-1)]';
    zs = sort([hs; -hs]) * i;
    
    %function
    gfn = @(t,s) 1./(t*ones(size(s.'))-ones(size(t))*s.');
    
    %get M
    ng = 32;    gs = sort(cos(pi*[0:ng]'/ng));    T = gfn(zs,gs);
    for g=1:size(T,2);        T(:,g) = T(:,g)/norm(T(:,g));    end
    if(0)
        [Q,R,ord] = qr(T,0);    gud = find(abs(diag(R))>EPS*abs(R(1)));    idx = ord(gud);
        ss = gs(idx);    S = T(:,idx); %S: skeleton
        M = S * diag(ss)*pinv(S);
    else
        M = T * diag(gs)*pinv(T,norm(T,'fro')*1e-4);
    end
    fprintf(1, 'MT-TD error: %d\n', norm(M*T-T*diag(gs))/norm(M*T));
end

for it=1:2
    if(    it==1)
        nx = 4;
        xs = [-0.9 -0.2 0.2 0.9]';    %xs = sort(rand(nx,1)*2-1);
        ws = ones(size(xs)); %xs = sort(rand(nx,1)*(2*B)-B);        %ws = (1 + rand(size(xs)))/2;
    elseif(it==2)
        nx = 4;
        xs = [-0.9 0 0.1 0.9]';    %xs = sort(rand(nx,1)*2-1);
        ws = ones(size(xs)); %xs = sort(rand(nx,1)*(2*B)-B);        %ws = (1 + rand(size(xs)))/2;
    end

    STDS = [1e-2 1e-3 1e-4];
    for is=1:numel(STDS)
        STD = STDS(is);
        %prepare u
        us = gfn(zs,xs)*ws;
        us = us .* (1+STD*(randn(nz,1) + i*randn(nz,1)));
        
        na = round(nx*1.5);
        A = zeros(numel(zs),na);
        A(:,1) = us;
        for g=1:na-1
            A(:,g+1) = M*A(:,g);
        end
        [tU,tS,tV] = svd(A,'econ');        tV = tV(:,1:nx);
        Psi = pinv(conj(tV(1:end-1,:)))*conj(tV(2:end,:));
        rts = eig(Psi);
        rts = real(rts); bad = find(abs(rts)>1); rts(bad) = rts(bad)./abs(rts(bad));
        
        %get solution
        xa = sort(rts);
        tmp = gfn(zs,xa);
        wa = [real(tmp);imag(tmp)]\[real(us);imag(us)];
        
        %postprocessing
        fun = @(y) sum(abs(gfn(zs,y(1:end/2))*y(end/2+1:end) - us).^2);        options = optimoptions(@fminunc,'Display','off');
        [y,fval] = fminunc (fun, [xa;wa]);
        xb = y(1:end/2);
        wb = y(end/2+1:end);
        
        %check
        vb = gfn(zs,xb)*wb; %app
        va = gfn(zs,xa)*wa;
        vs = gfn(zs,xs)*ws; %ext
        relerr = norm(vb-vs)/norm(vs);        %fprintf(1, '%d, %d\n', norm(va-us)/norm(us), norm(vb-us)/norm(us));
        
        FS=18;
        figure; clf; hold on; stem(xs, ws, 'b');        stem(xa, wa, 'g');    stem(xb, wb, 'r');
        set(gca, 'FontSize', FS);    bb=get(gca);    set(bb.XLabel, 'FontSize', FS);    set(bb.YLabel, 'FontSize', FS);    set(bb.ZLabel, 'FontSize', FS);    set(bb.Title, 'FontSize', FS);
        filename = sprintf('exS_%i%i',it,is);
        print(gcf, '-depsc', filename);
    end
end        
