rng(8);

if(1)
    nz = 32;
    eh = 1;
    
    %gfn = @(t,s) exp(i*2*pi*t*transpose(s));
    gfn = @(t,s) (s.').^t;
    
    %ng = 32;    gs = exp(2*pi*i*[1/2:ng]'/ng);         T = gfn(zs,gs);
    ng = 32;    tmp = [1/2:ng]'/ng - 1/2;    gs = exp(2*pi*i*tmp);
end

for it=1:3
    if(it==1)
        zs = [0:nz-1]'*eh;
    elseif(it==2)
        zs = zs + randn(size(zs))*0.1;
    else
        zs = sort(rand(nz,1)*nz);    
    end
    T = gfn(zs,gs);    for g=1:size(T,2);        T(:,g) = T(:,g)/norm(T(:,g));    end
    M = T * diag( exp(2*pi*i*tmp*eh) )*pinv(T,norm(T,'fro')*1e-2);
    
    FS=18;
    figure; imagesc(abs(M)); colorbar; axis equal; axis tight;
    set(gca, 'FontSize', FS);    bb=get(gca);    set(bb.XLabel, 'FontSize', FS);    set(bb.YLabel, 'FontSize', FS);    set(bb.ZLabel, 'FontSize', FS);    set(bb.Title, 'FontSize', FS);
    filename = sprintf('cmp_%i',it);
    print(gcf, '-depsc', filename);
end
