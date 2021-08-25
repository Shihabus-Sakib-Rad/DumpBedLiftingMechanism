% global mX mY mU mV mF max_F min_F max_all min_all max_abs min_abs;
global link_labels link_txt link_lengths l2_arr ar_x5 total l1a x4ab mSolx;

for j=1:6
    link_txt{1, j} =  sprintf('%s::  %.2f cm  ::  %.2f to %.2f KN',link_labels{j},link_lengths(j), min_F(1, j), max_F(1, j));
end
link_txt{1, 7} = sprintf('l2 range: %.2f to %.2f cm', l2_arr(1), l2_arr(total));
link_txt{1, 8} = sprintf('x5 range: %.2f to %.2f deg', ar_x5(1), ar_x5(total));
link_txt{1, 9} = sprintf('l1a offset: %.2f cm', l1a);
link_txt{1, 10} = sprintf('l4a-l4b angle: %.2f deg', rad2deg(x4ab));
link_txt{1, 11} = sprintf('l2 retracted angle: %.2f deg', rad2deg(mSolx(1,4)));
link_txt{1, 12} = sprintf('l3 retracted angle: %.2f deg', rad2deg(mSolx(1,5)));

global time
step = 3;
n = 1;
time = 1;

while n < 10
for i=1:step:total
    plot_graph(i)
end

for i=total:-step:1
    plot_graph(i)
end
n = n + 1;
end

function c = get_color(i , j)
    global mF max_abs min_abs;
    v = mF(i, j);
    if v > 0
        c = [v/max_abs 0 0];
    else
        v = abs(v);
        c = [0 0 v/min_abs];
    end
end

function plot_graph(i)
    global mX mY mU mV mF l2_arr l2_vel ar_x5 ar_x5_vel;
    global link_labels link_txt time;
    X = mX(i,:);
    Y = mY(i,:);
    xc = mU(i,:);
    yc = mV(i,:);
    hold off
    quiver(X(1:3), Y(1:3), xc(1:3), yc(1:3), 'AutoScale','off', 'ShowArrowHead', 'off', 'color', 'r', 'LineStyle', '--')
    hold on
    quiver(X(4), Y(4), xc(4), yc(4), 'AutoScale','off', 'LineWidth',3)
    text(xc(4), yc(4), {sprintf('%.1f cm', l2_arr(i)), sprintf('%.1f cm/s', l2_vel)});
    quiver(X(5), Y(5), xc(5), yc(5), 'AutoScale','off','ShowArrowHead', 'off', 'LineWidth',2)
    quiver(X(6:8), Y(6:8), xc(6:8), yc(6:8), 'AutoScale','off', 'ShowArrowHead', 'off', 'color', 'm', 'LineWidth',2)
    quiver(X(9), Y(9), xc(9), yc(9), 'AutoScale','off','ShowArrowHead', 'off', 'LineWidth',3)
    text(X(9), Y(9), {sprintf('%.2f deg', ar_x5(1, i)), sprintf('%.2f deg/s', ar_x5_vel(1, i))});
    for j=1:6
        jo = j +3;
        x_text = X(jo) + xc(jo)/2;
        y_text = Y(jo) + yc(jo)/2;
        text(x_text, y_text, sprintf('%s:: %.2f KN',link_labels{j}, mF(i, j)), 'color', get_color(i, j));
    end
    
    for j=1:6
        text(-50, 100, link_txt, 'color', 'b')
    end
    
    text(-50, 0, sprintf('%d', i), 'color', 'b')
    
    ylim([-10, 180]);
    xlim([-30, 200]);
    axis equal
    axis manual
    pause(time)
end
