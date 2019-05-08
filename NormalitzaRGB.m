function rg = NormalitzaRGB(im)
    im = double(im);
    aux = im(:,:,1) + im(:,:,2) + im(:,:,3);
    [files, cols, ~] = size(im);
    rg = uint8(zeros(files,cols,2));
    rg(:,:,1) = uint8(255*im(:,:,1)./aux);
    rg(:,:,2) = uint8(255*im(:,:,2)./aux);
end

