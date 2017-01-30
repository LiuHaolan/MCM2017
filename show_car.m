function [p_buf,accidents,cnt]=show_car(p_buf,bx,by,lanx,lany,cor,t,xt,xt1,min_d,intervals)
   
    v=7.5;
    len = size(p_buf);
    
    cnt=0;
    accidents=0;
%     xt = -60;
    s(1)=plot(-90,15,'color','r');
for i=2:len(1)
    t0=p_buf(i,2);
    j=p_buf(i,1);
    ran_num=p_buf(i,3);
    k=get_slope(bx(j),by(j),lanx(cor(j)),lany(cor(j)));
    cosk=1/sqrt(1+k^2);
    
    
    switch j
        case 1
                k=get_slope(bx(2),by(2),lanx(cor(j)),lany(cor(j)));
                yt=by(2)+(xt-bx(2))*k;                      % k stands for the straight line and k1 stands for the fork line
                k1=get_slope(bx(j),by(j),xt,yt);        % caculate the argument of the merge for optimization
                cosk1=1/sqrt(1+k1^2);
                x=bx(j)+(t-t0)*v*cosk1;
            if x<=xt
%                 x=bx(j)+(t-t0)*v*cosk1;
                y=by(j)+(x-bx(j))*k1; 
            else
                t1=t-t0- (xt-bx(j))/(v*cosk1);                      % t1 means the part of time that is on the original path
                x=xt+v*cosk*t1;
                y=yt+(x-xt)*k;
              
            end   
            
          case 4
                if ran_num==2
                    dx=-1;
                else
                    dx=1;
                end
                k=get_slope(bx(j+dx),by(j+dx),lanx(ran_num),lany(ran_num));
                yt1=by(j+dx)+(xt1-bx(j+dx))*k;                      % k stands for the straight line and k1 stands for the fork line
                k1=get_slope(bx(j),by(j),xt1,yt1);        % caculate the argument of the merge for optimization
                cosk1=1/sqrt(1+k1^2);
                x=bx(j)+(t-t0)*v*cosk1;
            if x<=xt1
%                 x=bx(j)+(t-t0)*v*cosk1;
                y=by(j)+(x-bx(j))*k1; 
            else
                t1=t-t0- (xt-bx(j))/(v*cosk1);                      % t1 means the part of time that is on the original path
                x=xt1+v*cosk*t1;
                y=yt1+(x-xt1)*k;
              
            end    
            
         case 7
                k=get_slope(bx(6),by(6),lanx(cor(j)),lany(cor(j)));
                yt=by(6)+(xt-bx(6))*k;                      % k stands for the straight line and k1 stands for the fork line
                k1=get_slope(bx(j),by(j),xt,yt);        % caculate the argument of the merge for optimization
                cosk1=1/sqrt(1+k1^2);
                x=bx(j)+(t-t0)*v*cosk1;
            if x<=xt
%                 x=bx(j)+(t-t0)*v*cosk1;
                y=by(j)+(x-bx(j))*k1; 
            else
                t1=t-t0- (xt-bx(j))/(v*cosk1);                      % t1 means the part of time that is on the original path
                x=xt+v*cosk*t1;
                y=yt+(x-xt)*k;
              
            end   
        otherwise
               
               x=bx(j)+(t-t0)*v*cosk;
               y=by(j)+(x-bx(j))*k; 
      
    end   
   
    if x<lanx(cor(j))
%         s(i) = plot(x,y,'color','r','marker','.','markersize',18);
            a(i,:)=[x y i];   
    else
            cnt=cnt+1;
            a(i,:)=[0 0 0];
    end
    
%     % debug
%     if i==len(1)
%         a
%     end
    
end
 
    
for i=2:len(1)
    if a(i,1)~=0
        flag=0;
        for j=2:(i-1)
            c=a(j,1)-a(i,1);
            d=(a(j,1)-a(i,1))^2+(a(j,2)-a(i,2))^2;
            if (c>0)&&(d<min_d)
                 flag=1;
%                 %debug
%                 a(i,1)
%                 a(i,2)
%                 a(j,1)
%                 a(j,2)
                flag=1;
                break;
            end   
        end
        
        
        for j=(i+1):len(1)
            c=a(j,1)-a(i,1);
            d=(a(j,1)-a(i,1))^2+(a(j,2)-a(i,2))^2;
            if (c>0)&&(d<min_d)
               
%                 %debug
%                 a(i,1)
%                 a(i,2)
%                 a(j,1)
%                 a(j,2)
                 flag=1;
                break;
            end   
        end
        
        s(i) =  plot(a(i,1),a(i,2),'color','r','marker','.','markersize',18);
        
        if flag==1
            p_buf(i,2)=p_buf(i,2)-1;
            accidents=accidents+1;
           
        end
    end
end    

    pause(intervals);                                     % set for the speed of your simulation

     len1=size(s);
for i=2:len1(2)
        delete(s(i)); 
end
    
end