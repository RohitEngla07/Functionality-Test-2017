load SGP_120k;

today = datenum('18-Oct-2010 10:30:0'); % ** SGP, IGRF data are created for this date **
equinox = datenum('21-Mar-2010 12:0:0'); % date of equinox

T = SGP_120k(1,:);
N = length(T);

Si_120k = zeros(4,N);

for i=1:N
    beta = 0;   %what is this? document this block.??
    time1 = today - equinox + T(i) / 86400;
    lambda = (2*pi*time1) / 365.256363;
    epsilon = 23.5 * pi / 180;

    sin_delta = cos(epsilon)*sin(beta) + sin(epsilon)*cos(beta)*sin(lambda);
    delta = asin(sin_delta);

    cos_alpha = cos(lambda) * cos(beta) / cos(delta);
    alpha = acos(cos_alpha);
    if (delta >= 0)
        alpha = alpha;
    else
        alpha = (2*pi - 2*alpha) + alpha;
    end

    x = cos(delta)*cos(alpha);
    y = cos(delta)*sin(alpha);
    z = sin(delta);

    v_Sun_i = [x; y; z];

    Si_120k(1,i) = T(i);
    Si_120k(2:4,i) = v_Sun_i;
    
    if mod(i,100000) == 0 
        fprintf('done %i\n',i/10)
    end

end

save Si_120k.mat Si_120k
