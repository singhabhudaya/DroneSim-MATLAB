function pid = init_pid()
    pid.Kp = [0.8; 0.8; 1.2];     % P: responsiveness
    pid.Ki = [0.01; 0.01; 0.02];  % I: smooth drift
    pid.Kd = [0.6; 0.6; 1.0];     % D: dampen bounce
end