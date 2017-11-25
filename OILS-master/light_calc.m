% constants
s_Rearth = 6378164;
s_AU = 159597870610;
s_Rsun = 695500000;
solar_constant = 1366;  % Considering constant illumination from the sun

% calc

load SGP_120k;
load Si_120k;

T = SGP_120k(1,:);
x = SGP_120k(2:4,:);
N = length(x);

light_120k = zeros(2,N);

for i=1:N
    v_pos_S_i = x(:,i);
    v_Sun_i = Si_120k(2:4,i);
    
    umbra = s_AU*s_Rearth / (s_Rsun - s_Rearth);
    penumbra = s_AU*s_Rearth / (s_Rsun + s_Rearth);

    alpha = asin(s_Rearth / umbra);
    beta = asin(s_Rearth / penumbra);

    angle_sat = acos(dot(v_pos_S_i, v_Sun_i) / norm(v_pos_S_i));

    parameter_umbra = acos((dot((v_pos_S_i + umbra*v_Sun_i), v_Sun_i)) / norm(v_pos_S_i + umbra*v_Sun_i));
    parameter_penumbra = acos((dot((v_pos_S_i - penumbra*v_Sun_i), -v_Sun_i)) / norm(v_pos_S_i - penumbra*v_Sun_i));

    flag = 1;

    if ((angle_sat >= pi/2 + alpha) && (parameter_umbra <= alpha))
        flag = 0;
    elseif ((angle_sat >= pi/2 + beta) && (parameter_umbra > alpha) && (parameter_penumbra <= beta))
        flag = 0.5;
    end
      
    if mod(i,10000) == 0 
        fprintf('done %i\n',i/10)
    end

    light_120k(1,i) = T(i);
    light_120k(2,i) = flag;
    
end

save light_120k.mat light_120k
