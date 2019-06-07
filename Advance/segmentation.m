function segmentada = segmentation(inputImage)
    im = double(rgb2hsv(inputImage));
    v = im(:,:,3);
    m_v = mean(v(:));
    sd_v = std(v(:));
    t_v = m_v + sd_v;
    im_tmp =  v > t_v;
    segmentacio = activecontour(im,im_tmp);
    ee = strel('disk', 17);
    segmentada = imopen(segmentacio, ee);
    ee = strel('disk', 5);
    segmentada = imclose(segmentada, ee);
    
end