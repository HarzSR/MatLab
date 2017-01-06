clc
close all
imaqreset;
vid=videoinput('winvideo',1);
set(vid,'ReturnedColorSpace','RGB');
preview(vid);
fprintf('Bring Image \n');
delay(2000);
im = getsnapshot(vid);
fprintf('Select Pixels on the intented Marker/Color : \n');
p = impixel(im);
[r c]=size(p);
red = mean(p(:,1));
grn = mean(p(:,2));
blu = mean(p(:,3));
[r c d]=size(im);
range = 20;   
while(1)
    im = getsnapshot(vid);
    output_image=zeros(r,c);  
    for i1=1:r
        for i2=1:c
            if( (im(i1,i2,1)>red-range) && (im(i1,i2,1)<red+range) && (im(i1,i2,2)>grn-range) && (im(i1,i2,2)<grn+range) && (im(i1,i2,3)>blu-range) && (im(i1,i2,3)<blu+range) )
                output_image(i1,i2)=1;
            end
        end
    end
    imshow(output_image);   
end
