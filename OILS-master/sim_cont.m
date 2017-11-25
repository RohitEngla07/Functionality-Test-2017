%%Simulation Continued
%Instructions - if sim needs to be continued from from time 't', put MM,
%GPS, Sun data to OBC, x data from respective logs at time 't'. 
%put t_init =  t. B_k_init shold be 

matched = 1;
iter = 1;
%%
t_init = 29732;
i_init = 1190;
today = datenum('18-Oct-2010 10:30:0')+ seconds(t_init);
today = datenum(today);
%%
while matched
    if(GPSlog(iter,1)==i_init)
        GPS_data_toOBC = GPSlog(iter,2:152);
        iter = 1;
        break;
    end
    iter = iter + 1;
end
%%
while matched
    if(sunlog(iter,1)==i_init)
        sun_toOBC = sunlog(iter,2:end);
        iter = 1;
        break;
    end
    iter = iter + 1;
end

while matched
    if(maglog(iter,1)==i_init)
        MM_data_toOBC_raw = maglog(iter,2:end);
        B_k_init = maglog(iter-1,2:end);
        iter = 1;
        break;
    end
    iter = iter + 1;
end

while matched
    if(currlog(iter,1)==i_init)
        i_fromOBC_init1 = currlog(iter,2:end);
        i_fromOBC_init2 = currlog(iter+1,2:end);
        iter = 1;
        break;
    end
    iter = iter + 1;
end
%%
while matched
    if(xlog(iter,1)==i_init)
        x = xlog(iter,2:end);
        break;
    end
    iter = iter + 1;
end
w_simcont = x(5:end);
q_BI0 = x(1:4)';
%%
save sim_cont.mat GPS_data_toOBC sun_toOBC  MM_data_toOBC_raw B_k_init ...
    i_fromOBC_init1 i_fromOBC_init2 w_simcont q_BI0 t_init today 