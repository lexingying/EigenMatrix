FS=18;


if(1)
    nx = 4;
    xs = [-0.9 0 0.5 0.9]';    %xs = sort(rand(nx,1)*2-1);
    ws = ones(size(xs)); %xs = sort(rand(nx,1)*(2*B)-B);        %ws = (1 + rand(size(xs)))/2;
    
    STD=1e-2;
    runF; xb'
    figure(1); clf; hold on; stem(xs, ws, 'b');        stem(xa, wa, 'g');    stem(xb, wb, 'r');
    set(gca, 'FontSize', FS);    bb=get(gca);    set(bb.XLabel, 'FontSize', FS);    set(bb.YLabel, 'FontSize', FS);    set(bb.ZLabel, 'FontSize', FS);    set(bb.Title, 'FontSize', FS);
    print(gcf, '-depsc', 'exF_1A');
    
    STD=1e-3;
    runF; xb'
    figure(2); clf; hold on; stem(xs, ws, 'b');        stem(xa, wa, 'g');    stem(xb, wb, 'r');
    set(gca, 'FontSize', FS);    bb=get(gca);    set(bb.XLabel, 'FontSize', FS);    set(bb.YLabel, 'FontSize', FS);    set(bb.ZLabel, 'FontSize', FS);    set(bb.Title, 'FontSize', FS);
    print(gcf, '-depsc', 'exF_1B');

    STD=1e-4;
    runF; xb'
    figure(3); clf; hold on; stem(xs, ws, 'b');        stem(xa, wa, 'g');    stem(xb, wb, 'r');
    set(gca, 'FontSize', FS);    bb=get(gca);    set(bb.XLabel, 'FontSize', FS);    set(bb.YLabel, 'FontSize', FS);    set(bb.ZLabel, 'FontSize', FS);    set(bb.Title, 'FontSize', FS);
    print(gcf, '-depsc', 'exF_1C');
end

if(1)
    nx = 4;
    xs = [-0.9 0 0.1 0.9]';    %xs = sort(rand(nx,1)*2-1);
    ws = ones(size(xs)); %xs = sort(rand(nx,1)*(2*B)-B);        %ws = (1 + rand(size(xs)))/2;
    
    STD=1e-2;
    runF; xb'
    figure(1); clf; hold on; stem(xs, ws, 'b');        stem(xa, wa, 'g');    stem(xb, wb, 'r');
    set(gca, 'FontSize', FS);    bb=get(gca);    set(bb.XLabel, 'FontSize', FS);    set(bb.YLabel, 'FontSize', FS);    set(bb.ZLabel, 'FontSize', FS);    set(bb.Title, 'FontSize', FS);
    print(gcf, '-depsc', 'exF_2A');
    
    STD=1e-3;
    runF; xb'
    figure(2); clf; hold on; stem(xs, ws, 'b');        stem(xa, wa, 'g');    stem(xb, wb, 'r');
    set(gca, 'FontSize', FS);    bb=get(gca);    set(bb.XLabel, 'FontSize', FS);    set(bb.YLabel, 'FontSize', FS);    set(bb.ZLabel, 'FontSize', FS);    set(bb.Title, 'FontSize', FS);
    print(gcf, '-depsc', 'exF_2B');

    STD=1e-4;
    runF; xb'
    figure(3); clf; hold on; stem(xs, ws, 'b');        stem(xa, wa, 'g');    stem(xb, wb, 'r');
    set(gca, 'FontSize', FS);    bb=get(gca);    set(bb.XLabel, 'FontSize', FS);    set(bb.YLabel, 'FontSize', FS);    set(bb.ZLabel, 'FontSize', FS);    set(bb.Title, 'FontSize', FS);
    print(gcf, '-depsc', 'exF_2C');
end