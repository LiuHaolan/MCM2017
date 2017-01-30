function drawboard(

for i=1:7
    bx(i)=-90;
    by(i)=15*i;
    plot(bx(i),by(i),'color','b','marker','.','markersize',40);
end

for i=1:4
    lanx(i)=-30;
    lany(i)=22.5+15*i;
    
%     x1=-90;
%     y1=-15+30*i;
     plot(lanx(i),lany(i),'color','b','marker','.','markersize',20);
     
end