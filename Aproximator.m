clear all;
close all;
clc;


load proj_fit_05.mat


x1 = id.X{1};
x2 = id.X{2};

y = id.Y;

xval1 = val.X{1};
xval2 = val.X{2};

yval = val.Y;

for n = 1:25
[u,v] = meshgrid(0:n);
uv = [u(:),v(:)];
uv(sum(uv,2) >= n+1,:) = [];

x = 1;
for i = 1:length(x1)
    for j = 1:length(x1)
    g =  x1(i).^uv(:,1).*x2(j).^uv(:,2);
        for k=1:length(g)
        PHI(x,k) = g(k);
        end
    x = x + 1;
    end
end

p = 1;
for i = 1:length(xval1)
    for j = 1:length(xval1)
    g =  xval1(i).^uv(:,1).*xval2(j).^uv(:,2);
        for k=1:length(g)
        PHIVAL(p,k) = g(k);
        end
    p = p + 1;
    end
end

yvec = y(:);
T = PHI \ yvec;

yAproxId = PHI * T;
yAproxVal = PHIVAL * T;

yAproxId = reshape(yAproxId,length(x1),length(x1));
yAproxVal = reshape(yAproxVal,length(xval1),length(xval1));

mseVAL(n) = immse(yval,yAproxVal);
mseID(n) = immse(y,yAproxId);

if(n >= 2)
    
    if(mseVAL(n-1) <= min(mseVAL))
        ok=1;
        yhatstar = yAproxVal;
        [minVal, minIdx] = min(mseVAL);
    end 
    
end

end

figure;

if(ok==1)
    mesh(xval1,xval2,yhatstar);title(['Best aprox grade ',num2str(minIdx),'th']);
else
    [minVal, minIdx] = min(mseVAL); 
    mesh(xval1,xval2,yAproxVal);title(['Best aprox grade ',num2str(minIdx),'th']);
end

figure
plot(mseID);title('MSE id vs MSE val');hold on;plot(mseVAL);
legend('MSE id','MSE val');xlabel('Grade');ylabel('MSE');
figure
plot(mseVAL);title('MSE validare');xlabel('Grade');ylabel('MSE');


