FS=18;

if(1)
    nx = 4;
    xs = [-0.9 0 0.5 0.9]'+1;    %xs = sort(rand(nx,1)*2-1);
    ws = ones(size(xs)); %xs = sort(rand(nx,1)*(2*B)-B);        %ws = (1 + rand(size(xs)))/2;
    
    STD=1e-5;
    runL; xb'-1
    figure(1); clf; hold on; stem(xs, ws, 'b');        stem(xa, wa, 'g');    stem(xb, wb, 'r');
    set(gca, 'FontSize', FS);    bb=get(gca);    set(bb.XLabel, 'FontSize', FS);    set(bb.YLabel, 'FontSize', FS);    set(bb.ZLabel, 'FontSize', FS);    set(bb.Title, 'FontSize', FS);
    print(gcf, '-depsc', 'exL_1A');
    
    STD=1e-6;
    runL; xb'-1
    figure(2); clf; hold on; stem(xs, ws, 'b');        stem(xa, wa, 'g');    stem(xb, wb, 'r');
    set(gca, 'FontSize', FS);    bb=get(gca);    set(bb.XLabel, 'FontSize', FS);    set(bb.YLabel, 'FontSize', FS);    set(bb.ZLabel, 'FontSize', FS);    set(bb.Title, 'FontSize', FS);
    print(gcf, '-depsc', 'exL_1B');

    STD=1e-7;
    runL; xb'-1
    figure(3); clf; hold on; stem(xs, ws, 'b');        stem(xa, wa, 'g');    stem(xb, wb, 'r');
    set(gca, 'FontSize', FS);    bb=get(gca);    set(bb.XLabel, 'FontSize', FS);    set(bb.YLabel, 'FontSize', FS);    set(bb.ZLabel, 'FontSize', FS);    set(bb.Title, 'FontSize', FS);
    print(gcf, '-depsc', 'exL_1C');
end

if(1)
    nx = 4;
    xs = [-0.9 0 0.25 0.9]'+1;    %xs = sort(rand(nx,1)*2-1);
    ws = ones(size(xs)); %xs = sort(rand(nx,1)*(2*B)-B);        %ws = (1 + rand(size(xs)))/2;
    
    STD=1e-5;
    runL; xb'-1
    figure(1); clf; hold on; stem(xs, ws, 'b');        stem(xa, wa, 'g');    stem(xb, wb, 'r');
    set(gca, 'FontSize', FS);    bb=get(gca);    set(bb.XLabel, 'FontSize', FS);    set(bb.YLabel, 'FontSize', FS);    set(bb.ZLabel, 'FontSize', FS);    set(bb.Title, 'FontSize', FS);
    print(gcf, '-depsc', 'exL_2A');
    
    STD=1e-6;
    runL; xb'-1
    figure(2); clf; hold on; stem(xs, ws, 'b');        stem(xa, wa, 'g');    stem(xb, wb, 'r');
    set(gca, 'FontSize', FS);    bb=get(gca);    set(bb.XLabel, 'FontSize', FS);    set(bb.YLabel, 'FontSize', FS);    set(bb.ZLabel, 'FontSize', FS);    set(bb.Title, 'FontSize', FS);
    print(gcf, '-depsc', 'exL_2B');

    STD=1e-7;
    runL; xb'-1
    figure(3); clf; hold on; stem(xs, ws, 'b');        stem(xa, wa, 'g');    stem(xb, wb, 'r');
    set(gca, 'FontSize', FS);    bb=get(gca);    set(bb.XLabel, 'FontSize', FS);    set(bb.YLabel, 'FontSize', FS);    set(bb.ZLabel, 'FontSize', FS);    set(bb.Title, 'FontSize', FS);
    print(gcf, '-depsc', 'exL_2C');
end


