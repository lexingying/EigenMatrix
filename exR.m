FS=18;

if(1)
    nx = 4;
    xs = 0.9 * exp(2*pi*i*[0.2;0.5;0.8;1]);
    ws = ones(size(xs)); %xs = sort(rand(nx,1)*(2*B)-B);        %ws = (1 + rand(size(xs)))/2;
    
    STD=1e-2;
    runR; xb.'
    figure(1); clf; hold on; set(gca,'DefaultLineMarkerSize',10); plot(gs,'k'); plot(xs, 'b+');        plot(xa, 'g+');    plot(xb, 'r+'); axis equal;
    set(gca, 'FontSize', FS);    bb=get(gca);    set(bb.XLabel, 'FontSize', FS);    set(bb.YLabel, 'FontSize', FS);    set(bb.ZLabel, 'FontSize', FS);    set(bb.Title, 'FontSize', FS);
    print(gcf, '-depsc', 'exR_1A');
    
    STD=1e-3;
    runR; xb.'
    figure(2); clf; hold on; set(gca,'DefaultLineMarkerSize',10); plot(gs,'k'); plot(xs, 'b+');        plot(xa, 'g+');    plot(xb, 'r+'); axis equal;
    set(gca, 'FontSize', FS);    bb=get(gca);    set(bb.XLabel, 'FontSize', FS);    set(bb.YLabel, 'FontSize', FS);    set(bb.ZLabel, 'FontSize', FS);    set(bb.Title, 'FontSize', FS);
    print(gcf, '-depsc', 'exR_1B');

    STD=1e-4;
    runR; xb.'
    figure(3); clf; hold on; set(gca,'DefaultLineMarkerSize',10); plot(gs,'k'); plot(xs, 'b+');        plot(xa, 'g+');    plot(xb, 'r+'); axis equal;
    set(gca, 'FontSize', FS);    bb=get(gca);    set(bb.XLabel, 'FontSize', FS);    set(bb.YLabel, 'FontSize', FS);    set(bb.ZLabel, 'FontSize', FS);    set(bb.Title, 'FontSize', FS);
    print(gcf, '-depsc', 'exR_1C');
end

pause;

if(1)
    nx = 4;
    xs = 0.9 * exp(2*pi*i*[0.2;0.75;0.8;1]);
    ws = ones(size(xs)); %xs = sort(rand(nx,1)*(2*B)-B);        %ws = (1 + rand(size(xs)))/2;
    
    STD=1e-2;
    runR; xb'
    figure(1); clf; hold on; set(gca,'DefaultLineMarkerSize',10); plot(gs,'k'); plot(xs, 'b+');        plot(xa, 'g+');    plot(xb, 'r+'); axis equal;
    set(gca, 'FontSize', FS);    bb=get(gca);    set(bb.XLabel, 'FontSize', FS);    set(bb.YLabel, 'FontSize', FS);    set(bb.ZLabel, 'FontSize', FS);    set(bb.Title, 'FontSize', FS);
    print(gcf, '-depsc', 'exR_2A');
    
    STD=1e-3;
    runR; xb'
    figure(2); clf; hold on; set(gca,'DefaultLineMarkerSize',10); plot(gs,'k'); plot(xs, 'b+');        plot(xa, 'g+');    plot(xb, 'r+'); axis equal;
    set(gca, 'FontSize', FS);    bb=get(gca);    set(bb.XLabel, 'FontSize', FS);    set(bb.YLabel, 'FontSize', FS);    set(bb.ZLabel, 'FontSize', FS);    set(bb.Title, 'FontSize', FS);
    print(gcf, '-depsc', 'exR_2B');

    STD=1e-4;
    runR; xb'
    figure(3); clf; hold on; set(gca,'DefaultLineMarkerSize',10); plot(gs,'k'); plot(xs, 'b+');        plot(xa, 'g+');    plot(xb, 'r+'); axis equal;
    set(gca, 'FontSize', FS);    bb=get(gca);    set(bb.XLabel, 'FontSize', FS);    set(bb.YLabel, 'FontSize', FS);    set(bb.ZLabel, 'FontSize', FS);    set(bb.Title, 'FontSize', FS);
    print(gcf, '-depsc', 'exR_2C');
end




%generate x on line
%nx = 4;
%xs = t2x(2*rand(nx,1)-1);
%ws = ones(size(xs));        %xs = sort(rand(nx,1)*(2*B)-B);        %ws = (1 + rand(size(xs)))/2;
        
        