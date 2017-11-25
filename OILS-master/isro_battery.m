function [y] = isro_battery(x, current, internal_resistance) %#eml

if x >= 0
    y = -1.9617e-030*x^10 + 2.0777e-026*x^9 - 9.3448e-023*x^8 + 2.3253e-019*x^7 - 3.4941e-016*x^6 + 3.2457e-013*x^5 - 1.8299e-010*x^4 + 5.871e-008*x^3 - 9.0949e-006*x^2 - 7.2522e-005*x + 4.0607 + 0.08*2.214 + current*internal_resistance;
else
    slope = (4.238-4.233)/20;
    y = 4.238 + slope*(0-x) + current*internal_resistance;
end

