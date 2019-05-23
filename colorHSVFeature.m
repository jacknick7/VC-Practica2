function [m,sd] = colorHSVFeature(im, imCont)
    im = double(rgb2hsv(im));
    imCont = imCont == 1;
    h = im(:,:,1);
    s = im(:,:,2);
    v = im(:,:,3);
    m_h = mean(h(imCont));
    m_s = mean(s(imCont));
    m_v = mean(v(imCont));
    m = [m_h m_s m_v];
    sd_h = std(h(imCont));
    sd_s = std(s(imCont));
    sd_v = std(v(imCont));
    sd = [sd_h sd_s sd_v];
end

