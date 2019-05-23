function [m,sd] = colorRGBFeature(im, imCont)
    im = double(im);
    imCont = imCont == 1;
    r = im(:,:,1);
    g = im(:,:,2);
    b = im(:,:,3);
    m_r = mean(r(imCont));
    m_g = mean(g(imCont));
    m_b = mean(b(imCont));
    m = [m_r m_g m_b];
    sd_r = std(r(imCont));
    sd_g = std(g(imCont));
    sd_b = std(b(imCont));
    sd = [sd_r sd_g sd_b];
end

