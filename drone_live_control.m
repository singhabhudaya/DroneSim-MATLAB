function drone_live_control
    % Initial state
    state = zeros(1, 9);
    pid = init_pid();
    target = [0; 0; 1];

    % Setup figure
    fig = figure('Name', 'Drone Control', 'NumberTitle', 'off');
    ax = axes('Parent', fig);
    hold(ax, 'on'); grid on; view(3);
    xlabel('X'); ylabel('Y'); zlabel('Z');
    axis([-5 5 -5 5 0 5]);
    fill3(ax, [-5 5 5 -5], [-5 -5 5 5], [0 0 0 0], [0.8 0.8 0.8], 'FaceAlpha', 0.2);

    % Drone visuals
    arm1 = plot3(ax, [0 0], [-0.3 0.3], [0 0], 'r', 'LineWidth', 2);
    arm2 = plot3(ax, [-0.3 0.3], [0 0], [0 0], 'g', 'LineWidth', 2);
    path = plot3(ax, 0, 0, 0, 'b.', 'MarkerSize', 10);

    % Sliders
    sx = uicontrol('Style','slider','Min',-5,'Max',5,'Value',0,...
        'Position',[80 60 200 20]);
    sy = uicontrol('Style','slider','Min',-5,'Max',5,'Value',0,...
        'Position',[80 35 200 20]);
    sz = uicontrol('Style','slider','Min',0,'Max',5,'Value',1,...
        'Position',[80 10 200 20]);

    uicontrol('Style','text','String','X Target','Position',[20 60 60 20]);
    uicontrol('Style','text','String','Y Target','Position',[20 35 60 20]);
    uicontrol('Style','text','String','Z Target','Position',[20 10 60 20]);

    uicontrol('Style','pushbutton','String','Reset',...
        'Position',[300 20 60 30],'Callback',@reset_path);

    % Data buffers
    trailX = [];
    trailY = [];
    trailZ = [];

    % MAIN LOOP
    while ishandle(fig)
        % Get slider values
        target = [sx.Value; sy.Value; sz.Value];

        % PID + dynamics
        err = target - state(1:3)';
        u = pid_controller(err, pid);
        dt = 0.05;
        state = drone_model(state, u, dt);

        % Drone position
        x = state(1); y = state(2); z = state(3);

        % Update visuals
        set(arm1, 'XData', [x x], 'YData', [y-0.3 y+0.3], 'ZData', [z z]);
        set(arm2, 'XData', [x-0.3 x+0.3], 'YData', [y y], 'ZData', [z z]);
        trailX(end+1) = x;
        trailY(end+1) = y;
        trailZ(end+1) = z;
        set(path, 'XData', trailX, 'YData', trailY, 'ZData', trailZ);

        drawnow;
        pause(dt);
    end

    % Reset button function
    function reset_path(~,~)
        trailX = state(1);
        trailY = state(2);
        trailZ = state(3);
        set(path, 'XData', trailX, 'YData', trailY, 'ZData', trailZ);
        drawnow;
    end
end