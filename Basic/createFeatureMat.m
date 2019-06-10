function featuresMat = createFeatureMat(n,m,ims,single)
    featuresMat = zeros(n, m);
    % Feature #1: Color mean of segmented flower (RGB),
    %             good for a lot of flowers but not so good for ones with
    %             a similar color or diferent inside the same class
    % Feature #2: Color standard desviation (RGB), up
    %             to 20% more accuracy with mean
    % Feature #3: Relation borderline/area, may help when color is not
    %             enought, compacitat
    % Feature #4: Corner detection, with Harris, number of petals
    % Feature #5: Histogram of Orientated Gradients
    for i = 1:m
        if single
            path = ims;
        else
            path = ims.Files{i};
        end
        pathCont = [path(1:end-3) 'png'];
        imI = imread(path);
        imContI = imread(pathCont);
        [m,sd] = colorRGBFeature(imI, imContI);
        featuresMat(1:3,i) = m;
        featuresMat(4:6,i) = sd;
        comp = compactnessFeature(imContI);
        featuresMat(7,i) = comp;
        nCor = cornerFeature(imI, imContI);
        featuresMat(8,i) = nCor;
        iIntI = imContI == 1;
        maskedRgbImage = bsxfun(@times, imI, cast(iIntI, 'like', imI));
        H = HOGFeature(imresize(rgb2gray(maskedRgbImage), [32 32]));
        featuresMat(9:89,i) = H;
    end
end

