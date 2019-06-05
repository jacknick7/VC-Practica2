function nPoints = cornerFeature(im,imCont)
    imRest = imCont ~= 1;
    imGray = rgb2gray(im);
    imGray(imRest) = 0;
    % Aplicar filtre Gaussia abans de redimensionar?
    imGrayRes = imresize(imGray,0.25);
    points = detectHarrisFeatures(imGrayRes);
    nPoints = points.Count;
end

