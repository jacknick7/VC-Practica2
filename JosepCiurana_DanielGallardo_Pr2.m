%% Pràctica 2, Reconeixemet automàtic de flors
addpath(genpath('../Segmentades'))

flors = {'BotodOr'; 'Buixol'; 'Crocus'; 'DentdeLleo'; 'Fadrins';
    'Fritillaria'; 'Gerbera'; 'Girasol'; 'Hemerocallis';
    'Lliri'; 'Narcis'; 'Viola'};
florsN = size(flors);
% for i = 1:florsN(1)
%     imFilesPNG = dir(['../Segmentades/' flors{i} '/*.png']);
%     imN = length(imFilesPNG);
%     for j = 1:imN
%        imContNameJ = imFilesPNG(j).name;
%        imflorsICont{j} = imread(imContNameJ);
%        imNameJ = [imContNameJ(1:end-3) 'jpg'];
%        imflorsI{j} = imread(imNameJ);
%     end
%     % Revisar això últim
%     [n, m] = size(imflorsI);
%     nm = m * 0.8;
%     imflors{i} = imflorsI{1:nm};
%     imflorsCont{i} = imflorsICont{1:nm};
% end
imFilesPNG = dir(['../Segmentades/' flors{1} '/*.png']);
imN = length(imFilesPNG);
for j = 1:imN
   imContNameJ = imFilesPNG(j).name;
   imflorsICont{j} = imread(imContNameJ);
   imNameJ = [imContNameJ(1:end-3) 'jpg'];
   imflorsI{j} = imread(imNameJ);
end
imshow(imflorsICont{1},[])
figure, imshow(imflorsI{1})

%% Histo
close all
im = imflorsI{1};
%imshow(im)
rg = NormalitzaRGB(im);
%[files, cols, chan] = size(rg);
%figure,imshow(rg(:,:,1)), title('component r')
%figure, imshow(rg(:,:,2)), title('component g')
%figure, imshow(uint8(ones(files, cols))*255-rg(:,:,1)-rg(:,:,2)), title('component b')
%rg=rg(248:272,92:156,:);
%calcul de l'histograma
h1 = histo2D(rg,imflorsICont{1},16);
h1 = imgaussfilt(h1,0.5);
%figure, surf(h1)
sim = zeros(13,1);
for i = 1:13
 im = imflorsI{i};
 figure, imshow(im)
 rg = NormalitzaRGB(im);
 %rg=rg(248:272,92:156,:);
 h = histo2D(rg,imflorsICont{i},16);
 h = imgaussfilt(h,0.5);
 aux = min(h1, h);
 sim(i) = sum(aux(:));
end
figure, bar(sim), title('similitud entre imatges')
figure, imshow(imflorsI{1})

%% Histo HSV

