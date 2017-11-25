u = [1.10346946156169e-05,-9.47328932073574e-06,-1.61842255862861e-05];

X = int16( abs(u(1)) * 30000 * 1e4 / 2.0);
Y = int16( abs(u(2)) * 30000 * 1e4 / 2.0);
Z = int16( abs(u(3)) * 30000 * 1e4 / 2.0);
d = [X Y Z];
d1 = [];
for iter = 1: 3
    d1 = [d1 fliplr(typecast(int16(d(iter)), 'uint8'))];
end