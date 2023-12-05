img = imread('image.jpg');
img = rgb2gray(img);


sigma = 1; 
fsize = 5; 
tlow = 0.1; 
thigh = 0.3; 

g = fspecial('gaussian', fsize, sigma);
img = imfilter(img, g, 'same');

gx = [-1 0 1; -2 0 2; -1 0 1]; 
gy = gx'; 
imgx = imfilter(img, gx, 'same'); 
imgy = imfilter(img, gy, 'same'); 
mag = sqrt(imgx.^2 + imgy.^2); 
dir = atan2(imgy, imgx); 

nms = zeros(size(img)); 
for i = 2:size(img, 1) - 1
    for j = 2:size(img, 2) - 1
        if (dir(i, j) >= 0 && dir(i, j) < pi/4) || (dir(i, j) < -3*pi/4 && dir(i, j) >= -pi)
            p1 = mag(i, j+1);
            p2 = mag(i, j-1);
        elseif (dir(i, j) >= pi/4 && dir(i, j) < pi/2) || (dir(i, j) < -pi/2 && dir(i, j) >= -3*pi/4)
            p1 = mag(i+1, j+1);
            p2 = mag(i-1, j-1);
        elseif (dir(i, j) >= pi/2 && dir(i, j) < 3*pi/4) || (dir(i, j) < -pi/4 && dir(i, j) >= -pi/2)
            p1 = mag(i+1, j);
            p2 = mag(i-1, j);
        else
            p1 = mag(i+1, j-1);
            p2 = mag(i-1, j+1);
        end
        
        if mag(i, j) >= p1 && mag(i, j) >= p2
            nms(i, j) = mag(i, j);
        else
            nms(i, j) = 0;
        end
    end
end

tlow = tlow * max(nms(:));
thigh = thigh * max(nms(:));
emap = zeros(size(img)); 
for i = 1:size(img, 1)
    for j = 1:size(img, 2)
        if nms(i, j) < tlow 
            emap(i, j) = 0;
        elseif nms(i, j) > thigh 
            emap(i, j) = 1;
        else
            if any(any(nms(max(i-1, 1):min(i+1, size(img, 1)), max(j-1, 1):min(j+1, size(img, 2))) > thigh))
                emap(i, j) = 1;
            else
                emap(i, j) = 0;
            end
        end
    end
end

imshow(emap);