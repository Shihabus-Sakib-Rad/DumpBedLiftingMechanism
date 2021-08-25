% syms l1c l2 l3 l4a l4b l5;
global mSolx mX mY mU mV mF max_F min_F max_all min_all max_abs min_abs l2_arr l2_vel ar_x5 ar_x5_vel l5 l1a x4ab;
global link_labels link_txt link_lengths total time_for_step;
syms x1c x2 x3 x4a x4b x5;
syms F2 F3 F4a F4b F4c F5;


link_labels = {'l2', 'l3', 'l4a', 'l4b', 'l4c', 'l5'};
link_lengths = zeros(1, 6);
link_txt = cell(1, 8);


% Applied force and vector
F = 40; %KN
rf = [0; -1]; % vertically downward

l4a = 90;
l4b = 20;
x4ab = deg2rad(145);
l4c = trig_arm(l4a, l4b, x4ab);
x4bc = trig_angle(l4b, l4c, l4a);

l5 = 200;
l1a = 10;
l1b = l5;
l1c = sqrt(l1a^2 + l1b^2);
x1c = asin(l1a/l1b);
x1a = pi/2;
x1b = -pi;


x41a_r = deg2rad(80);
l2_r = trig_arm(l1a, l4a, x41a_r);
x42_r = trig_angle(l2_r, l4a, l1a);
x24b_r = x4ab - x42_r;
l3 = trig_arm(l2_r, l4b, x24b_r);
link_lengths(1, :) = [l2_r l3 l4a l4b l4c l5];
l2_min = l2_r;
l2_max = l3+l4b - 2;
l2_step = 0.5;
time = 30;
time_for_step = l2_step * time/(l2_max - l2_min);
l2_vel = (l2_max - l2_min)/time;
l2_arr = l2_min:l2_step:l2_max;
sz_a = size(l2_arr);
sz = sz_a(2);
mSolx = zeros(sz, 9);
mX = zeros(sz, 9);
mY = zeros(sz, 9);
mU = zeros(sz, 9);
mV = zeros(sz, 9);
mF = zeros(sz, 6);
max_F = zeros(1, 6);
min_F = zeros(1, 6);

ar_x5 = zeros(1, sz);
ar_x5_vel = zeros(1, sz);

i = 1;
for l2 = l2_arr
eqn1 = l2*cos(x2) + l4a*cos(x4a) - l5*cos(x5) - l1c*cos(x1c) == 0;
eqn2 = l2*sin(x2) + l4a*sin(x4a) - l5*sin(x5) - l1c*sin(x1c) == 0;
eqn3 = l3*cos(x3) + l4b*cos(x4b) - l2*cos(x2) == 0;
eqn4 = l3*sin(x3) + l4b*sin(x4b) - l2*sin(x2) == 0;
eqn5 = x4a + x4ab - x4b - pi == 0;

eqns = [eqn1 eqn2 eqn3 eqn4 eqn5];
vars = [x2 x3 x4a x4b x5];

if i > 1
%     [i mSolx(i-1,4)]
    range = [-0.5 pi/2;-0.5 mSolx(i-1,4);-0.5 pi;0 pi;pi/2 pi+0.5];
    else
    range = [-0.5 pi/2;-0.5 pi/2;-0.5 pi;0 pi;pi/2 pi+0.5];
end
sol = vpasolve(eqns, vars, range);

x4c = sol.x4b + x4bc;
ar_x5(1, i) = rad2deg(pi - sol.x5);
ar_x5_vel(1, 1) = 0;
if i ~= 1
    ar_x5_vel(1, i) = (ar_x5(1, i) - ar_x5(1, i-1))/time_for_step;
end

x = [x1a x1b x1c sol.x2 sol.x3 sol.x4a sol.x4b x4c sol.x5];
l = [l1a l1b l1c l2 l3 l4a l4b l4c l5];
xc = l .* cos(x);
yc = l .* sin(x);

X = [0 xc(3) 0 0 0 xc(4) xc(5) xc(5) xc(3)];
Y = [0 yc(3) 0 0 0 yc(4) yc(5) yc(5) yc(3)];
mSolx(i,:) = x;
mX(i,:) = X;
mY(i,:) = Y;
mU(i,:) = xc;
mV(i,:) = yc;


r2 = [xc(4); yc(4)]./ l2;
r3 = [xc(5); yc(5)]./ l3;
r4a = [xc(6); yc(6)]./ l4a;
r4b = [xc(7); yc(7)]./ l4b;
r4c = [xc(8); yc(8)]./ l4c;
r5 = [xc(9); yc(9)]./ l5;

eqn6 = F5*r5 + F4a*r4a + F4c*r4c + F*rf == [0; 0];
eqn7 = F2*r2 - F4a*r4a + F4b*r4b == [0; 0];
eqn8 = F3*r3 - F4c*r4c -F4b*r4b == [0; 0];

eqns2 = [eqn6 eqn7 eqn8];
vars2 = [F2 F3 F4a F4b F4c F5];
sol = vpasolve(eqns2, vars2);

mF(i,:) = [sol.F2 sol.F3 sol.F4a sol.F4b sol.F4c sol.F5];

i = i + 1;
end
total = i - 1;

for n=1:6
    max_F(1, n) = max(mF(:, n));
    min_F(1, n) = min(mF(:, n));
end

max_all = max(max_F);
min_all = min(min_F);
max_abs = abs(max_all);
min_abs = abs(min_all);


save("ws.mat");

function C = trig_angle(a, b, c)
    C = acos((a ^ 2 + b ^ 2 - c ^ 2) / (2 * a * b));
end

function c = trig_arm(a, b, C)
    c = sqrt(a ^ 2 + b ^ 2 - 2 * a * b * cos(C));
end

function sol = solve_for(l2)
global x1c x2 x3 x4a x4b x4c x5
eqn1 = l2*cos(x2) + l4a*cos(x4a) - l5*cos(x5) - l1c*cos(x1c) == 0;
eqn2 = l2*sin(x2) + l4a*sin(x4a) - l5*sin(x5) - l1c*sin(x1c) == 0;
eqn3 = l3*cos(x3) + l4b*cos(x4b) - l2*cos(x2) == 0;
eqn4 = l3*sin(x3) + l4b*sin(x4b) - l2*sin(x2) == 0;
eqn5 = x4a + x4ab - x4b - pi == 0;

eqns = [eqn1 eqn2 eqn3 eqn4 eqn5];
vars = [x2 x3 x4a x4b x5];
range = [-0.5 pi/2;-0.5 pi/2;-0.5 pi;0 pi;pi/2 pi+0.5];
sol = vpasolve(eqns, vars, range);
end
