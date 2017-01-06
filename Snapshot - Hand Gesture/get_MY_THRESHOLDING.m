function [red grn blu]=get_MY_THRESHOLDING(im)
p = impixel(im);
[r c]=size(p);
red = mean(p(:,1));
grn = mean(p(:,2));
blu = mean(p(:,3));
[r c d]=size(im);
output_image=zeros(r,c);
range = 20;
for i1=1:r
    for i2=1:c
        if( (im(i1,i2,1)>red-range) && (im(i1,i2,1)<red+range) && (im(i1,i2,2)>grn-range) && (im(i1,i2,2)<grn+range) && (im(i1,i2,3)>blu-range) && (im(i1,i2,3)<blu+range) )
            output_image(i1,i2)=1;
        end
    end
end
figure();
imshow(output_image);
end
