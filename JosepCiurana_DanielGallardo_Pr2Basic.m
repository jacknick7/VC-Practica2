%% Check Image Data Folder Exists
imageFolder = '../SegmentadesBasic';
if ~exist(imageFolder,'dir')
    disp('Image folder not found, please change imageFolder var');
end

%% Load Images
imds = imageDatastore(imageFolder, 'LabelSource', 'foldernames', ...
    'IncludeSubfolders',true, 'FileExtensions', '.jpg');
tbl = countEachLabel(imds)
% Determine the smallest amount of images in a category
minSetCount = min(tbl{:,2});
% Use splitEachLabel method to trim the set.
imds = splitEachLabel(imds, minSetCount, 'randomize');
% Notice that each set now has exactly the same number of images.
countEachLabel(imds)

%% Prepare Training and Test Image Sets
[trainSet, testSet] = splitEachLabel(imds, 0.7, 'randomize');

%% Extract Training Features
nFeatures = 6;
[nTrain, ~] = size(trainSet.Labels);
trainFeatures = zeros(nFeatures, nTrain);
%Color Mean
for i = 1:nTrain
    %trainSet.Files{i}
    [m,sd] = colorFeature(trainSet.Files{i});
    trainFeatures(1,i) = m(1,1);
    trainFeatures(2,i) = m(1,2);
    trainFeatures(3,i) = m(1,3);
    trainFeatures(4,i) = sd(1,1);
    trainFeatures(5,i) = sd(1,2);
    trainFeatures(6,i) = sd(1,3);
end

%% Train A Multiclass SVM Classifier Using Flower Features
% Get training labels from the trainSet
trainLabels = trainSet.Labels;

% Train multiclass SVM classifier using a fast linear solver, and set
% 'ObservationsIn' to 'columns' to match the arrangement used for training
% features.
classifier = fitcecoc(trainFeatures, trainLabels, ...
    'Learners', 'Linear', 'Coding', 'onevsall', 'ObservationsIn', 'columns');

%% Evaluate Classifier
[nTest, ~] = size(testSet.Labels);
testFeatures = zeros(nFeatures, nTest);
%Color Mean
for i = 1:nTest
    [m,sd] = colorFeature(testSet.Files{i});
    testFeatures(1,i) = m(1,1);
    testFeatures(2,i) = m(1,2);
    testFeatures(3,i) = m(1,3);
    testFeatures(4,i) = sd(1,1);
    testFeatures(5,i) = sd(1,2);
    testFeatures(6,i) = sd(1,3);
end

% Pass image features to trained classifier
predictedLabels = predict(classifier, testFeatures, 'ObservationsIn', 'columns');

% Get the known labels
testLabels = testSet.Labels;

% Tabulate the results using a confusion matrix.
confMat = confusionmat(testLabels, predictedLabels);

% Convert confusion matrix into percentage form
confMat = bsxfun(@rdivide,confMat,sum(confMat,2))

% Display the mean accuracy
mean(diag(confMat))

