% This is the main MATLAB script for Lab 4.
%
% You will need to modify the Mbed code and this script, but should not need to make any other changes.
%
%% SET YOUR INPUTS HERE

% Bezier curve control points
% const_point = [0.16; -0.14]; %[x;y] or [q1,q2] constant coordinate (x,q1,q2 coordinates should be opposite sign due to direction motors are mounted)
% pts_foot = repmat(const_point,1,8);
       
% pts_foot = []; % YOUR BEZIER PTS HERE
%   pts_foot = [
%    
%        0.1055    0.1055    0.1055   -0.0055   -0.2303   -0.1734   -0.1734   -0.1734;
%       -0.1595   -0.1595   -0.1595   -0.2850   -0.1814    0.0113    0.0113    0.0113
%    ]


%%%NEED TO CHECK IF IT IS IN WORKSPACE
axis1=0.1;
axis2=0.1;
x=linspace(0,2*pi,20);
pts_foot = [axis1*cos(x); axis2*cos(x)]
% Initial leg angles for encoder resets (negative of q1,q2 in lab handout due to direction motors are mounted)
angle1_init = 0;
angle2_init = -pi/2; 

angle3_init = 0;
angle4_init = -pi/2; 

% Total experiment time is buffer,trajectory,buffer
traj_time         = 1;
pre_buffer_time   = 2; % this should be 0 for constant points, 2 for Bezier trajectories
post_buffer_time  = 2;

% Gains for impedance controller
% If a gain is not being used in your Mbed code, set it to zero
% For joint space control, use K_xx for K1, K_yy for K2, D_xx for D1, D_yy for D2
gains.K_xx = 100.0;
gains.K_yy = 100.0;
gains.K_xy = 0;

gains.D_xx = 2;
gains.D_yy = 2;
gains.D_xy = 0;

K_xx2 = 100.0;
K_yy2 = 100.0;
K_xy2 = 0;

D_xx2 = 2;
D_yy2 = 2;
D_xy2 = 0;

% Maximum duty cycle commanded by controller (should always be <=1.0)
duty_max   = .5;

%% Run Experiment
[output_data] = Experiment_trajectory( angle1_init, angle2_init, pts_foot,...
                                       traj_time, pre_buffer_time, post_buffer_time,...
                                       gains, duty_max, K_xx2, Kyy2, D_xx2, D_yy2, D_xy2, duty_max2);

%% Extract data
t = output_data(:,1);
x = -output_data(:,12); % actual foot position in X (negative due to direction motors are mounted)
y = output_data(:,13); % actual foot position in Y
   
xdes = -output_data(:,16); % desired foot position in X (negative due to direction motors are mounted)
ydes = output_data(:,17); % desired foot position in Y

%% Plot foot vs desired
figure(3); clf;
subplot(211); hold on
plot(t,xdes,'r-'); plot(t,x);
xlabel('Time (s)'); ylabel('X (m)'); legend({'Desired','Actual'});

subplot(212); hold on
plot(t,ydes,'r-'); plot(t,y);
xlabel('Time (s)'); ylabel('Y (m)'); legend({'Desired','Actual'});

figure(4); clf; hold on
plot(xdes,ydes,'r-'); plot(x,y,'k');
xlabel('X (m)'); ylabel('Y (m)'); legend({'Desired','Actual'});

% for Cartesian constant points, un-comment this to see the virtual potential well on figure 4
% [X, Y] = meshgrid(linspace(-0.25,0.25,50),linspace(-0.25,0.1,50));
% eX = X - (-const_point(1)); 
% eY = Y - const_point(2); 
% V = 0.5*gains.K_xx*eX.*eX + 0.5*gains.K_yy*eY.*eY + gains.K_xy*eX.*eY;
% axis([-0.25, 0.25, -0.25, 0.1]);
% contour(X,Y,V,15,'LineWidth',1.5);

