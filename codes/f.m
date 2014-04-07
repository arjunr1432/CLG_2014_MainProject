function y = f(centX1, centY1, centX2, centY2, centX3, centY3)
     u = [1 0 ];
     v = [0 1 ];  
     x = [0 0 ];
     
     u(1)=centX1;
     u(2)=centY1;
     
     x(1)=centX2;
     x(2)=centY2;     
     
     v(1)=centX3;
     v(2)=centY3;
     
     u=u-x;
     v=v-x;
     
     CosTheta = dot(u,v)/(norm(u)*norm(v));
     y = uint16(acos(CosTheta)*180/pi);
         