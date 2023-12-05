input_image = imread('input.jpg');

gray = rgb2gray(input_image);

sobel_x = edge(gray, 'sobel', [], 'horizontal');
sobel_y = edge(gray, 'sobel', [], 'vertical');

mag = sqrt(sobel_x.^2 + sobel_y.^2);
ang = atan2(sobel_y, sobel_x);

mag = uint8(255 * mat2gray(mag));

ang = mod(rad2deg(ang), 180);

imshow(input_image);
title('Input Image');
figure;
imshow(mag);
title('Magnitude');
figure;
imshow(ang);
title('Angle');
