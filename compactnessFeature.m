function comp = compactnessFeature(imCont)
    im = imCont == 1;
    area = sum(im(:));
    cont = edge(im,'Canny');
    cont = sum(cont(:));
    comp = cont^2/area;
end

