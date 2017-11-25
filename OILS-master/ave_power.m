%average power estimator
%considers average power generation after the 15th orbit

t3 = [10*6000 : 1 : 120000];
sum = 0;
del = diff(t3);
Excess_pow = interp1(t2 , Excess_power , t3);
for i = [1:length(del)]
    incr = ((Excess_pow(i) + Excess_pow(i+1))/2)*del(i);
    sum = sum+incr;
end

average_ex_pow = sum/(120000 - 15*6000)