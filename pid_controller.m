function u = pid_controller(err, pid)
    persistent int_err prev_err
    if isempty(int_err)
        int_err = zeros(3,1);
        prev_err = zeros(3,1);
    end

    % Integral term
    int_err = int_err + err;

    % Derivative term
    derr = err - prev_err;
    prev_err = err;

    % PID output
    u = pid.Kp .* err + pid.Ki .* int_err + pid.Kd .* derr;
end