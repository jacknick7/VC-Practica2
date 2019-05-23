function featuresMat = createFeatureMat(n,m,imds)
    featuresMat = zeros(n, m);
    % Feature #1: Color mean of segmented flower (RGB now, upgrade to HSV),
    %             good for a lot of flowers but not so good for ones with
    %             a similar color or diferent inside the same class
    % Feature #2: Color standard desviation (RGB now, upgrade to HSV), up
    %             to 20% more accuracy with mean
    % Feature #3: Relation borderline/area, may help when color is not
    %             enought (testing needed) Compacitat
    % Feature #4: Corner detection, with Harris? Number of petals
    for i = 1:m
        path = imds.Files{i};
        pathCont = [path(1:end-3) 'png'];
        imI = imread(path);
        imContI = imread(pathCont);
        [m,sd] = colorRGBFeature(imI, imContI);
        featuresMat(1:3,i) = m;
        featuresMat(4:6,i) = sd;
        [m,sd] = colorHSVFeature(imI, imContI);
        featuresMat(7:9,i) = m;
        featuresMat(10:12,i) = sd;
        comp = compactnessFeature(imContI);
        featuresMat(13,i) = comp;
    end
end
