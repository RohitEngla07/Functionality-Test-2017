function q_BI0 = euler2qBI(roll0,pitch0,yaw0)
    R_BO = euler_to_rotmatrix(roll0, pitch0, yaw0);
    q_BO0 = rotmatrix_to_quaternion(R_BO);

    load SGP_120k;
    r = SGP_120k(2:4,1);   % position vector in ECI
    v = SGP_120k(5:7,1);   % velocity vector in ECI
    clear SGP_120k;
    
    oy = cross(v,r);       % orbit frame y...
    oy = oy/sqrt(dot(oy,oy));
    
    oz = -r/sqrt(dot(r,r));
    
    ox = cross(oy,oz);
    ox = ox/sqrt(dot(ox,ox));
    
    TOI0 = [ox oy oz]';

    q_OI0 = rotmatrix_to_quaternion(TOI0);

    q_BO0x = ...
    [ q_BO0(4)  q_BO0(3) -q_BO0(2) q_BO0(1);
     -q_BO0(3)  q_BO0(4)  q_BO0(1) q_BO0(2);
      q_BO0(2) -q_BO0(1)  q_BO0(4) q_BO0(3);
     -q_BO0(1) -q_BO0(2) -q_BO0(3) q_BO0(4)];

    q_BI0 = q_BO0x*q_OI0;

end