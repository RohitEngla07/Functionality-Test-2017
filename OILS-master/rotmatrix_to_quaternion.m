function q_out= rotmatrix_to_quaternion(Q)
%Converts the 3x3 rotation matrix Q into a 4 element column vector q_out (
%quaternion ).
%By Saurabh Chatterjee
% Corrected by HH; June 30, 2009

T = Q(1,1) + Q(2,2) + Q(3,3); %Trace

% if(T>0 )             % Why is this needed?
    r = sqrt(1+T);
    s = 0.5/r;              % 1/(4*eta) of Hughes; p. 18
    w = 0.5*r;              % scalar: cos (phi/2) = eta of Hughes, p. 18
    
    % The following by Saurabh gives conjugate quaternion!
    % x = (Q(3,2)-Q(2,3))*s;
    % y = (Q(1,3)-Q(3,1))*s;
    % z = (Q(2,1)-Q(1,2))*s;
    
    % Corrections according to Hughes and Markley's convention
    x = (Q(2,3)-Q(3,2))*s;
    y = (Q(3,1)-Q(1,3))*s;
    z = (Q(1,2)-Q(2,1))*s;
    
    % Saurabh is using [scalar; vector] convention!
    % q_out = [ w; x; y; z ];
    
    q_out = [ x; y; z; w];
    
    %else
    %disp(['script rotmatrix_to_quaternion inadequate: Trace = ' num2str(T)]);
    %q_out = [ -1; -1; -1; -1 ];      What's the meaning of this?
    %Remember to substitute
end