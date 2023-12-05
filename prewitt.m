img = imread('image.jpg');
img = rgb2gray(img);

filtered_image = zeros(size(img));

Mx = [-1 0 1; -1 0 1; -1 0 1]; % horizontal mask
My = [-1 -1 -1; 0 0 0; 1 1 1]; % vertical mask

for i = 2:size(img, 1) - 1
    for j = 2:size(img, 2) - 1
        Gx = sum(sum(Mx.*img(i:i+2, j:j+2)));
        Gy = sum(sum(My.*img(i:i+2, j:j+2)));
        
        filtered_image(i, j) = sqrt(Gx.^2 + Gy.^2);
        dir(i, j) = atan2(Gy, Gx);
    end
end

nms = zeros(size(img));
for i = 2:size(img, 1) - 1
    for j = 2:size(img, 2) - 1
        if (dir(i, j) >= 0 && dir(i, j) < pi/4) || (dir(i, j) < -3*pi/4 && dir(i, j) >= -pi)
            p1 = filtered_image(i, j+1);
            p2 = filtered_image(i, j-1);
        elseif (dir(i, j) >= pi/4 && dir(i, j) < pi/2) || (dir(i, j) < -pi/2 && dir(i, j) >= -3*pi/4)
            p1 = filtered_image(i+1, j+1);
            p2 = filtered_image(i-1, j-1);
        elseif (dir(i, j) >= pi/2 && dir(i, j) < 3*pi/4) || (dir(i, j) < -pi/4 && dir(i, j) >= -pi/2)
            p1 = filtered_image(i+1, j);
            p2 = filtered_image(i-1, j);
        else
            p1 = filtered_image(i+1, j-1);
            p2 = filtered_image(i-1, j+1);
        end
        
        if filtered_image(i, j) >= p1 && filtered_image(i, j) >= p2
            nms(i, j) = filtered_image(i, j);
        else
            nms(i, j) = 0;
        end
    end
end

tlow = 0.1; 
thigh = 0.3; 
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