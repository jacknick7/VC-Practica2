function histo = histoColor(im,cont)
rg = NormalitzaRGB(im);
histo = histo2D(rg,cont{1},16);
histo = imgaussfilt(histo,0.5);
end

