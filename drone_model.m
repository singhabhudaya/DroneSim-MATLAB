function next_state = drone_model(state, u, dt)
    pos = state(1:3);
    vel = state(4:6);
    acc = u;

% Add velocity damping (air resistance)
damping = 0.9;  % Between 0 (full stop) and 1 (no damping)
new_vel = damping * (vel + acc' * dt);
    new_pos = pos + new_vel*dt;

    % Clamp position
    new_pos(1) = max(min(new_pos(1), 5), -5);
    new_pos(2) = max(min(new_pos(2), 5), -5);
    new_pos(3) = max(min(new_pos(3), 5), 0);

    % Clamp velocity if at wall
    if new_pos(1) == 5 || new_pos(1) == -5
        new_vel(1) = 0;
    end
    if new_pos(2) == 5 || new_pos(2) == -5
        new_vel(2) = 0;
    end
    if new_pos(3) == 0 || new_pos(3) == 5
        new_vel(3) = 0;
    end

    next_state = [new_pos new_vel state(7:9)];
end