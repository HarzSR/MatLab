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
fprintf('Bring Markers....\n');
delay(2000);
fprintf('Thresolding for RED Marker\n');
im = getsnapshot(vidobj);
[RD_M_R RD_M_G RD_M_B] = get_MY_THRESHOLDING(im);
delay(300);
fprintf('Thresolding for YELLOW Marker\n');
[YL_M_R YL_M_G YL_M_B] = get_MY_THRESHOLDING(im);
delay(300);
close all
    import java.awt.Robot;
    import java.awt.event.*;
    mouse = Robot;
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
    imshow(output_image_r);   
    [r_cent_r c_cent_r]=centroid1(output_image_r);
     disp([r_cent_r c_cent_r]);
    for i1=1:r
      for i2=1:c
        if( (im(i1,i2,1)>YL_M_R-range) && (im(i1,i2,1)<YL_M_R+range) && (im(i1,i2,2)>YL_M_G-range) && (im(i1,i2,2)<YL_M_G+range) && (im(i1,i2,3)>YL_M_B-range) && (im(i1,i2,3)<YL_M_B+range) )
            output_image_y(i1,i2)=1;
        end
      end
    end
    [r_cent_y c_cent_y]=centroid1(output_image_y);
    disp([r_cent_y c_cent_y]);
    r = sqrt( ((r_cent_r)-(r_cent_y)).^2 + ((c_cent_r)-(c_cent_y)).^2 ); 
    disp(r);
    mouse.mouseMove(0, 0);
    mouse.mouseMove(((8.2)*(160 - c_cent_r)),(6.7*(r_cent_r)));  
    if(r<50)
      mouse.mousePress(InputEvent.BUTTON3_MASK);
    mouse.mouseRelease(InputEvent.BUTTON3_MASK);
    delay(500)
    end
end
