function hist = histo2D(rg,seg,Nbins)
    hist = double(zeros(Nbins));
    [files, cols, chans] = size(rg);
    aux = double(256/Nbins);
    segLim = max(seg(:));
    nPix = 0;
    for i = 1:files
        for j = 1:cols
            if seg(i,j) == segLim
                r = min(rg(i,j,1)/aux+1, 16);
                g = min(rg(i,j,2)/aux+1, 16);
                % r = double(rg(i,j,1))/aux;
                % g = double(rg(i,j,2))/aux;
                hist(r,g) = hist(r,g)+1;
                nPix = nPix + 1;
            end
        end
    end
    hist = hist/nPix;
end