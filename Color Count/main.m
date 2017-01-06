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
fprintf('Bring Colors\n');          
delay(2000);
fprintf('Thresolding for 1st Color\n'); 
im = getsnapshot(vidobj);           
[RD_M_R RD_M_G RD_M_B] = get_MY_THRESHOLDING(im);
delay(300);
fprintf('Thresolding for 2nd Color\n');
[GR_M_R GR_M_G GR_M_B] = get_MY_THRESHOLDING(im);  
delay(300);
fprintf('Thresolding for 3rd Color\n');
[YL_M_R YL_M_G YL_M_B] = get_MY_THRESHOLDING(im);  
delay(300);
close all
while(1)
    trigger(vidobj);            
    im=getdata(vidobj);         
    [r c d]=size(im);
    output_image_r=zeros(r,c);  
    output_image_g=zeros(r,c);  
    output_image_y=zeros(r,c);  
    count = 0;                  
   for i1=1:r
    for i2=1:c
        if( (im(i1,i2,1)>RD_M_R-range) && (im(i1,i2,1)<RD_M_R+range) && (im(i1,i2,2)>RD_M_G-range) && (im(i1,i2,2)<RD_M_G+range) && (im(i1,i2,3)>RD_M_B-range) && (im(i1,i2,3)<RD_M_B+range) )
            output_image_r(i1,i2)=1;
        end
    end
   end
    total_pix_r=sum(sum(output_image_r)); 
     if (total_pix_r>40)
         count = count + 1;
     end
   for i1=1:r
    for i2=1:c
        if( (im(i1,i2,1)>GR_M_R-range) && (im(i1,i2,1)<GR_M_R+range) && (im(i1,i2,2)>GR_M_G-range) && (im(i1,i2,2)<GR_M_G+range) && (im(i1,i2,3)>GR_M_B-range) && (im(i1,i2,3)<GR_M_B+range) )
            output_image_g(i1,i2)=1;
        end
    end
   end
    total_pix_g=sum(sum(output_image_g));  
     if (total_pix_g>40)
         count = count + 1;
     end
   for i1=1:r
    for i2=1:c
        if( (im(i1,i2,1)>YL_M_R-range) && (im(i1,i2,1)<YL_M_R+range) && (im(i1,i2,2)>YL_M_G-range) && (im(i1,i2,2)<YL_M_G+range) && (im(i1,i2,3)>YL_M_B-range) && (im(i1,i2,3)<YL_M_B+range) )
            output_image_y(i1,i2)=1;
        end
    end
   end
    total_pix_y=sum(sum(output_image_y));   
     if (total_pix_y>40)
         count = count + 1;
     end
     imshow(output_image_r + output_image_g + output_image_y)
  if(count==1)
     disp('one');
  elseif(count==2)
     disp('two');
  elseif(count==3)  
     disp('three');
  else
     disp('No finger'); 
  end
  clear count;  
end
