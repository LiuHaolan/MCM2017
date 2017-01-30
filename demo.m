clc;clear;clf;
figure('name', 'booth and lanes');

min_acc=1;
m_xt=0;
m_xt1=0;
xindex=1;
xtarr=zeros(1,11);
for xt=-65:1:-55 
    for xt1=-65:1:-65

% xt=-65;             % 65 seems to be pretty good
% xt1=-65;
intervals=0.2;  % the intervals betweeen every frame 
min_d=25;       % minimium distance between two cars

Arrival=4; % the mean total number of cars that arrives 
dt = 0.2; % time step
hold on;axis equal;%建立坐标系
axis([-110 -10 0 110]);
%axis off   % 除掉Axes

bx=zeros(1,7);    % the x,y of the booth
by=zeros(1,7);
for i=1:7
    bx(i)=-90;
    by(i)=15*i;
    plot(bx(i),by(i),'color','b','marker','.','markersize',40);
end
    
lanx=zeros(1,4);  % the x y of lanes
lany=zeros(1,4);
for i=1:4
    lanx(i)=-30;
    lany(i)=22.5+15*i;
    
%     x1=-90;
%     y1=-15+30*i;
     plot(lanx(i),lany(i),'color','b','marker','.','markersize',20);
end

    % guys! design the path here if you want
    % the main path 
    plot([bx(2),lanx(1)],[by(2),lany(1)],'color','b');
    plot([bx(3),lanx(2)],[by(3),lany(2)],'color','b');
    plot([bx(5),lanx(3)],[by(5),lany(3)],'color','b');
    plot([bx(6),lanx(4)],[by(6),lany(4)],'color','b');
    % the fork for optimization
    k=get_slope(bx(2),by(2),lanx(1),lany(1));
    yt=by(2)+(xt-bx(2))*k;    
    plot([bx(1),xt],[by(1),yt],'color','b');
    k=get_slope(bx(6),by(6),lanx(4),lany(4));
    yt=by(6)+(xt-bx(6))*k;    
    plot([bx(7),xt],[by(7),yt],'color','b');
       % the fork for optimization
    k=get_slope(bx(3),by(3),lanx(2),lany(2));
    yt1=by(3)+(xt1-bx(3))*k;    
    plot([bx(4),xt1],[by(4),yt1],'color','b');
     k=get_slope(bx(5),by(5),lanx(3),lany(3));
     yt1=by(5)+(xt1-bx(5))*k;    
    plot([bx(4),xt1],[by(4),yt1],'color','b');
    
n=7;
iterations=500;
cor=[1 1 2 2 3 4 4];
p_buf = zeros(1,3);  
t=0;
acc_sum=0;
car_num=0;
getThrough=0;


        
for i = 1:iterations
    number_cars =min( poissrnd(Arrival*dt,1), n);
    car_num = car_num + number_cars;
    
    if number_cars > 0 
        x = randperm(n);
        for j = 1:number_cars
            tmp=size(p_buf);
            if x(j)~=4
                p_buf(tmp(1)+1,:)=[x(j) t 0];
            else
                ran_num=rand();
                if ran_num>0.5
                    p_buf(tmp(1)+1,:)=[x(j) t 2];
                else
                    p_buf(tmp(1)+1,:)=[x(j) t 3];
                end
%             car_flow(bx(j),by(j),lanx(cor(j)),lany(cor(j)));
            end
        end
    end      
    [p_buf,accidents,cnt]=show_car(p_buf,bx,by,lanx,lany,cor,t,xt,xt1,min_d,intervals);
    getThrough=cnt;
    acc_sum = acc_sum+accidents;
    t=t+1;
    
   
    
    
    
end
     acc_rate=acc_sum/car_num;
    arrive_rate=getThrough/t;
    
    xtarr(xindex)=acc_rate;
    xindex=xindex+1;
    if min_acc>acc_rate
        min_acc=acc_rate;
        m_xt=xt;
        m_xt1=xt1;
    end
    
    end
end

xtarr
figure('name','accidents with xt');
n=1:(xindex-1);
plot(n,xtarr);


    