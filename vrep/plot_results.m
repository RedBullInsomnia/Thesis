function plot_results(t, positions)

%% Arms
figure
% Left Arm
subplot(6, 1, 1)
plot(t, positions(1,:));
ylabel('Left shoulder roll'); 
% y = get(gca,'YLabel');set(y,'Rotation', 0);
% set(y, 'Units', 'Normalized', 'Position', [-0.1, 0.5, 0]);
set(gca,'xtick',[], 'ytick', -150:50:100, 'Ylim' , [-100 100])

subplot(6, 1, 2)
plot(t, positions(2,:));
ylabel('Left shoulder pitch');
% y = get(gca,'YLabel');set(y,'Rotation', 0);
% set(y, 'Units', 'Normalized', 'Position', [-0.1, 0.5, 0]);
set(gca,'xtick',[], 'ytick', -150:50:100, 'Ylim' , [-100 100])

subplot(6, 1, 3)
plot(t, positions(3,:));
ylabel('Left elbow');
% y = get(gca,'YLabel');set(y,'Rotation', 0);
% set(y, 'Units', 'Normalized', 'Position', [-0.1, 0.5, 0]);
set(gca,'xtick',[], 'ytick', -150:50:100, 'Ylim' , [-100 100])

% Right arm
subplot(6, 1, 4)
plot(t, positions(4,:));
ylabel('Right shoulder roll');
% y = get(gca,'YLabel');set(y,'Rotation', 0);
% set(y, 'Units', 'Normalized', 'Position', [-0.09, 0.5, 0]);
set(gca,'xtick',[], 'ytick', -150:50:100, 'Ylim' , [-100 100])

subplot(6, 1, 5)
plot(t, positions(5,:));
ylabel('Right shoulder pitch'); 
% y = get(gca,'YLabel');set(y,'Rotation', 0);
% set(y, 'Units', 'Normalized', 'Position', [-0.1, 0.5, 0]);
set(gca,'xtick',[], 'ytick', -150:50:100, 'Ylim' , [-100 100])

subplot(6, 1, 6)
plot(t, positions(6,:));
ylabel('Right elbow') ;  
xlabel('Time (s)');
% y = get(gca,'YLabel');set(y,'Rotation', 0);
% set(y, 'Units', 'Normalized', 'Position', [-0.1, 0.5, 0]);
set(gca,'ytick', -150:50:100, 'Ylim', [-100 100])

set(gcf, 'paperunits', 'inches');
Lx = 10; Ly = 12;
set(gcf, 'papersize', [Lx Ly]); 
set(gcf, 'PaperPosition', [0.02*Lx 0.02*Ly 1.02*Lx 1.02*Ly]);
print -dpdf sup2proneArms.pdf;

%% Legs
figure
% Left leg
subplot(4, 1, 1)
plot(t, positions(7,:));
ylabel('Left hip yaw')
set(gca,'xtick',[], 'ytick', -150:50:100, 'Ylim', [-100 100])

subplot(4, 1, 2)
plot(t, positions(9,:));
ylabel('Left hip pitch')
set(gca,'xtick',[], 'ytick', -150:50:100, 'Ylim', [-100 100])

% Right leg
subplot(4, 1, 3)
plot(t, positions(13,:));
ylabel('Right hip yaw');
set(gca,'xtick',[], 'ytick', -150:50:100, 'Ylim', [-100 100])

subplot(4, 1, 4)
plot(t, positions(15,:));
ylabel('Right hip pitch')
xlabel('Time (s)');
set(gca, 'ytick', -150:50:100, 'Ylim', [-100 100])

set(gcf, 'paperunits', 'inches');
Lx = 10; Ly = 8;
set(gcf, 'papersize', [Lx Ly]); 
set(gcf, 'PaperPosition', [0.02*Lx 0.02*Ly 1.02*Lx 1.02*Ly]);
print -dpdf sup2proneLegs.pdf;

end