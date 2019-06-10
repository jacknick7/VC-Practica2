close all, clear variables
addpath('../Features/');

if exist('./bestRelClass.mat','file')
    load bestRelClass
    load maxAcc
    maxAcc
else
    %% Check Image Data Folder Exists
    imageFolder = '../../Segmentades';
    if ~exist(imageFolder,'dir')
        disp('Image folder not found, please change imageFolder var');
    end

    %% Load Images
    disp('Reading image DB...');
    imds = imageDatastore(imageFolder, 'LabelSource', 'foldernames', ...
        'IncludeSubfolders',true, 'FileExtensions', '.jpg');
    disp('Done!');
    imageDB = countEachLabel(imds)
    imdsNamesStr = string(imds.Files);

    %% Extract Image Features
    nFeatures = 89;
    [nDS, ~] = size(imds.Labels);
    disp('Extracting image features...');
    imdsFeatures = createFeatureMat(nFeatures, nDS, imds, false);
    disp('Done!');

    maxAcc = 0;
    Acc = [];
    for iter = 1:15
        %% Prepare Training and Test Image Sets
        [trainSet, testSet] = splitEachLabel(imds, 0.8, 'randomize');
        disp('Train/test random split with ratio 4:1');
        trainDB = countEachLabel(trainSet)
        testDB = countEachLabel(testSet)

        %% Build Features Matrix
        [nTrain, ~] = size(trainSet.Labels);
        disp('Choosing train images...');
        trainFeatures = zeros(nFeatures, nTrain);
        for i = 1:nTrain
            index = find(imdsNamesStr(:) == trainSet.Files{i});
            trainFeatures(:,i) = imdsFeatures(:,index);
        end
        disp('Done!');

        [nTest, ~] = size(testSet.Labels);
        disp('Choosing test images...');
        testFeatures = zeros(nFeatures, nTest);
        for i = 1:nTest
            index = find(imdsNamesStr(:) == testSet.Files{i});
            testFeatures(:,i) = imdsFeatures(:,index);
        end
        disp('Done!');

        %% Train A Multiclass SVM Classifier Using Flower Features
        % Get training labels from the trainSet
        trainLabels = trainSet.Labels;

        % Train multiclass SVM classifier using a fast linear solver, and set
        % 'ObservationsIn' to 'columns' to match the arrangement used for training
        % features.
        disp('Training SVM...');
        classifier = fitcecoc(trainFeatures, trainLabels, ...
            'Learners', 'Linear', 'Coding', 'onevsall', 'ObservationsIn', 'columns');
        disp('Done!');

        %% Evaluate Classifier
        % Pass image features to trained classifier
        predictedLabels = predict(classifier, testFeatures, 'ObservationsIn', 'columns');

        % Get the known labels
        testLabels = testSet.Labels;

        % Tabulate the results using a confusion matrix.
        confMat = confusionmat(testLabels, predictedLabels);

        % Convert confusion matrix into percentage form
        confMat = bsxfun(@rdivide,confMat,sum(confMat,2));

        % Print confusion matrix with labels
        labels = cellstr(classifier.ClassNames);
        array2table(confMat,'RowNames',labels,'VariableNames',labels)

        % Display the mean accuracy
        accuracy = mean(diag(confMat))

        if accuracy > maxAcc
            maxAcc = accuracy;
            bestRelClass = classifier;
        end
        Acc = [Acc accuracy];
        % Mean 5 iterations code:
        % 55,4 RGB mean, RGB sd, HSV mean + sd, compactness bad
        % 53,2 RGB mean, RGB sd
        % 58,4 RGB mean, RGB sd, compactness
        % 65,6 RGB mean, RGB sd, compactness, #corners
        % 72,2 RGB mean, RGB sd, compactness, #corners, HOG
    end
    mean(Acc)
    std(Acc)
    maxAcc
    save bestRelClass
    save maxAcc
end

%% Classify our own images
path = input('Please, specify image path: ','s');
while ~exist(path, 'file') 
    path = input('Wrong path. Please, specify image path: ','s');
end

disp('Extracting image features...');
imFeatures = createFeatureMat(nFeatures,1,path,true);
disp('Done!');

[predictedLabel,score,error] = predict(bestRelClass, imFeatures, 'ObservationsIn', 'columns');

if sum(abs(error)) > 21
    predictedLabel(1,1) = "Zero";
end

im = imread(path);
ImageName = strsplit(path, {'\','/'});
ImageName = string(ImageName{end});%1.7458
PredictedClass = string(predictedLabel(1,1));
table(ImageName,PredictedClass)
figure, imshow(im), title("Predicted class: " + PredictedClass)