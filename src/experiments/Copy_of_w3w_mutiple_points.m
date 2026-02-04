function calculate_radius_raw()
    % Calculates raw radius for 128-bit entropy and max theoretical entropy.
    % No text labels like "Solar System" or "Status".
    
    clc;
    fprintf('=== Raw Radius & Entropy Calculations ===\n');
    fprintf('%-6s | %-20s | %-15s\n', 'Points', 'Radius for 128-bit', 'Max Earth Entropy');
    fprintf('%-6s | %-20s | %-15s\n', '(n)', '(km)', '(at 20,000 km)');
    fprintf('--------------------------------------------------\n');
    
    % Constants
    H_target  = 128;      % 128 bits
    H_cell    = 45.7;     % 45.7 bits
    A_cell    = 9;        % 9 m^2
    R_EARTH   = 20000;    % 20,000 km
    
    for n = 1:5
        % 1. Max Entropy Calculation (at R = 20,000 km)
        if n == 1
            H_max = H_cell;
        else
            r_earth_m = R_EARTH * 1000;
            H_r_earth = log2(pi * r_earth_m^2 / A_cell);
            H_max     = H_cell + (n-1) * max(0, H_r_earth);
        end
        
        % 2. Required Radius Calculation
        if n == 1
            r_km = Inf; % Never reaches 128
        else
            % Formula: r = sqrt( (A * 2^((H_t - H_c)/(n-1))) / pi )
            exponent = (H_target - H_cell) / (n-1);
            area_ratio = 2^exponent;
            r_meters = sqrt( (A_cell * area_ratio) / pi );
            r_km = r_meters / 1000;
        end
        
        % 3. Formatting
        if r_km == Inf
            r_str = "Inf";
        elseif r_km > 1e6
            % Use scientific notation for massive numbers
            r_str = sprintf("%.2e", r_km);
        else
            % Use standard float for readable numbers
            r_str = sprintf("%.4f", r_km);
        end
        
        fprintf('%-6d | %-20s | %-15.2f\n', n, r_str, H_max);
    end
    fprintf('--------------------------------------------------\n');
end