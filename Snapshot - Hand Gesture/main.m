clc                         
close all
fprintf('wait please\n');   
imaqreset                   
clear all                   
vidobj = videoinput('winvideo',1);      
set(vidobj,'ReturnedColorSpace','RGB'); 
set(vidobj,'FramesPerTrigger',1);       
set(vidobj,'TriggerRepeat',inf);        
triggerconfig(vidobj,'manual');         
start(vidobj);
range=20;
fprintf('Bring Color\n');
delay(2000);
fprintf('Thresolding for 1st Color\n');
im = getsnapshot(vidobj);
[RD_M_R RD_M_G RD_M_B] = get_MY_THRESHOLDING(im);
delay(2000);
fprintf('Thresolding for 2nd Color\n');
[YL_M_R YL_M_G YL_M_B] = get_MY_THRESHOLDING(im);
delay(300);
close all
counter=0;
while(1)
    trigger(vidobj);            
    im=getdata(vidobj);         
    [r c d]=size(im);
    output_image_r=zeros(r,c);  
    output_image_y=zeros(r,c);  
    A=0;
   for i1=1:r
    for i2=1:c
        if( (im(i1,i2,1)>RD_M_R-range) && (im(i1,i2,1)<RD_M_R+range) && (im(i1,i2,2)>RD_M_G-range) && (im(i1,i2,2)<RD_M_G+range) && (im(i1,i2,3)>RD_M_B-range) && (im(i1,i2,3)<RD_M_B+range) )
            output_image_r(i1,i2)=1;
        end
    end
   end
   figure(2),imshow(output_image_r);
         title('1st Color');
      [r_cent_r c_cent_r]=centroid1(output_image_r);
      disp([r_cent_r c_cent_r]);
   for i1=1:r
    for i2=1:c
        if( (im(i1,i2,1)>YL_M_R-range) && (im(i1,i2,1)<YL_M_R+range) && (im(i1,i2,2)>YL_M_G-range) && (im(i1,i2,2)<YL_M_G+range) && (im(i1,i2,3)>YL_M_B-range) && (im(i1,i2,3)<YL_M_B+range) )
            output_image_y(i1,i2)=1;
        end
    end
   end
         figure(3),imshow(output_image_y); 
         title('2nd Color');
     [r_cent_y c_cent_y]=centroid1(output_image_y);
     disp([r_cent_y c_cent_y]);
     r = sqrt( ((r_cent_r) - (r_cent_y)).^2 + ((c_cent_r) - (c_cent_y)).^2 )
     if(r<70)
         delay(2000);
         Image=getsnapshot(vidobj);
         figure(4),imshow(Image);     
         counter=counter+1;
         savename = strcat('C:\Users\GM HARZ HH TPR\Desktop\image_' ,num2str(counter), '.jpg');          imwrite(Image, savename);
         folder = 'C:\Users\GM HARZ HH TPR\Desktop';
         baseFileName = 'image_1.jpg';
         fullFileName = fullfile(folder, baseFileName);
         if ~exist(fullFileName, 'file')
             fullFileName = baseFileName; 
	         if ~exist(fullFileName, 'file')
		         errorMessage = sprintf('Error: %s does not exist.', fullFileName);
		         uiwait(warndlg(errorMessage));
		         return;
             end
         end
     end
end
