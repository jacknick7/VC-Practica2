function comp = compactnessFeature(imCont)
    im = imCont == 1;
    area = sum(im(:));
    sob = fspecial('sobel');
    Soby = sob/4;
    Sobx = Soby';
    grady = imfilter(double(im), Soby, 'conv');
    gradx = imfilter(double(im), Sobx, 'conv');
    mod = sqrt(gradx.^2+grady.^2);
    cont = mod > 0;
    cont = sum(cont(:));
    comp = cont/area;
end

