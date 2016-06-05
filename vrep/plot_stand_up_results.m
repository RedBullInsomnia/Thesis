function plot_results(t, positions)

%% Arms
figure
set(0,'defaulttextInterpreter','none') 
% Arms
subplot(3, 1, 1)
plot(t, positions(1,:));
ylabel('Shoulder roll (°)'); 
% y = get(gca,'YLabel');set(y,'Rotation', 0);
% set(y, 'Units', 'Normalized', 'Position', [-0.1, 0.5, 0]);
set(gca,'xtick',[], 'ytick', -150:50:100, 'Ylim' , [-100 100])

subplot(3, 1, 2)
plot(t, positions(2,:));
ylabel('Shoulder pitch (°)');
% y = get(gca,'YLabel');set(y,'Rotation', 0);
% set(y, 'Units', 'Normalized', 'Position', [-0.1, 0.5, 0]);
set(gca,'xtick',[], 'ytick', -150:50:100, 'Ylim' , [-100 100])

subplot(3, 1, 3)
plot(t, positions(3,:));
ylabel('Elbows'' angle (°)');
xlabel ('Time (s)');
% y = get(gca,'YLabel');set(y,'Rotation', 0);
% set(y, 'Units', 'Normalized', 'Position', [-0.1, 0.5, 0]);
set(gca,'ytick', -150:50:100, 'Ylim' , [-100 100])

set(gcf, 'paperunits', 'inches');
Lx = 10; Ly = 6;
set(gcf, 'papersize', [Lx Ly]); 
set(gcf, 'PaperPosition', [0.02*Lx 0.02*Ly 1.02*Lx 1.02*Ly]);
print -dpdf prone2standArms.pdf;

%% Legs
figure
% Left leg
subplot(3, 1, 1)
plot(t, positions(9,:));
ylabel('Hips yaw (°)')
set(gca,'xtick',[], 'ytick', -150:50:100, 'Ylim', [-100 100])

subplot(3, 1, 2)
plot(t, positions(10,:));
ylabel('Knees'' angle (°)')
set(gca,'xtick',[], 'ytick', -150:50:100, 'Ylim', [-100 100])

% Right leg
subplot(3, 1, 3)
plot(t, positions(11,:));
ylabel('Feet''s angle(°)');
xlabel ('Time (s)');
set(gca, 'ytick', -150:50:100, 'Ylim', [-100 100])

set(gcf, 'paperunits', 'inches');
Lx = 10; Ly = 6;
set(gcf, 'papersize', [Lx Ly]); 
set(gcf, 'PaperPosition', [0.02*Lx 0.02*Ly 1.02*Lx 1.02*Ly]);
print -dpdf prone2standLegs.pdf;

end