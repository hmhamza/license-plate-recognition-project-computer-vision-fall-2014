
function [flag,result]=CHECK(inputImage)

    re_rows=500;
    re_cols=400;
    inputImage = imresize(inputImage,[re_rows  re_cols]);
      
    actualImages=['A.jpg';'B.jpg';'C.jpg';'D.jpg';'E.jpg';'F.jpg';'G.jpg';'H.jpg';'I.jpg';'J.jpg';'K.jpg';'L.jpg';'M.jpg';'N.jpg';'O.jpg';'P.jpg';'Q.jpg';'R.jpg';'S.jpg';'T.jpg';'U.jpg';'V.jpg';'W.jpg';'X.jpg';'Y.jpg';'Z.jpg';'0.jpg';'1.jpg';'2.jpg';'3.jpg';'4.jpg';'5.jpg';'6.jpg';'7.jpg';'8.jpg';'9.jpg';];
   
    matches=0;
    index=1;
    for q=1:36
       address='./Templates/';
       x=actualImages(q,:);
       address=strcat(address,x);
       actual = imread(address);
       actual = imresize(actual,[re_rows re_cols ]);
       actual=rgb2gray(actual);
       actual=im2bw(actual,0.5);        %0.3
       actual=~actual;
       %figure, imshow(actual);
       
       count=0;
       for y=1:re_rows
           for x=1:re_cols
               if (actual(y,x)==inputImage(y,x))
                  count=count+1;
               end
           end
           
       end 
           
        if(count>matches)
            matches=count;
            index=q;
        end
    
       
    end
      


    flag='false';
    result='@';
    if(matches>150000)
        flag='true';
        result=actualImages(index,1);
        %result=AlphaNumerics(index);
    end
    
end