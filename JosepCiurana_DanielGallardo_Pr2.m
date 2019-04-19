%% Pràctica 2, Reconeixemet automàtic de flors
addpath(genpath('../Segmentades'))

flors = {'BotodOr'; 'Buixol'; 'Crocus'; 'DentdeLleo'; 'Fadrins';
    'Fritillaria'; 'Gerbera'; 'Girasol'; 'Hemerocallis';
    'Lliri'; 'Narcis'; 'Viola'};
florsN = size(flors);
for i = 1:florsN(1)
    imFilesPNG = dir(['../Segmentades/' flors{i} '/*.png']);
    imN = length(imFilesPNG);
    for j = 1:imN
       imContNameJ = imFilesPNG(j).name;
       imflorsICont{j} = imread(imContNameJ);
       imNameJ = [imContNameJ(1:end-3) 'jpg'];
       imflorsI{j} = imread(imNameJ);
    end
    % Revisar això últim
    [n, m] = size(imflorsI);
    nm = m * 0.8;
    imflors{i} = imflorsI{1:nm};
    imflorsCont{i} = imflorsICont{1:nm};
end

