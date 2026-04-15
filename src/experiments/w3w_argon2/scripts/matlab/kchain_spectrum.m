function kchain_spectrum()
% KChain_Spectrum.m
% GeoVault Security: KDF Chaining as a Standalone Hardening Axis
%
% Shows how KDF chaining depth k (at fixed m=1024 MiB) shifts the
% security spectrum.  Analogous to Hardening_Spectrum (which sweeps m).
%
% Empirical basis:
%   R_GPU(k=1, m=1024 MiB) = 53.7 H/s  (measured, RTX 3090 Ti)
%   R_GPU(k)   = 53.7 / k   (conservative upper bound, CPU ratios <= 1.029)
%   W_base(n)  = W values from tab:combined_spatial_computational at m=1024
%
% Output: KChain_Spectrum.pdf  (save to mdpi/img/)

    clear; clc;

    % ── Parameters ────────────────────────────────────────────────────────
    T_Human  = 1e10;    % insecure / human-scale boundary
    T_BIP39  = 1e32;    % human-scale / super-secure boundary

    % W_base: attacker time-to-compromise at k=1, m=1024 MiB.
    % Values taken directly from tab:combined_spatial_computational (m=1024 row).
    % Index 1..5 corresponds to n=1..5 spatial points.
    W_base_spatial = [9.9e11, 2.1e26, 3.8e39, 7.1e52, 1.33e66];
    n_points       = 1:5;

    % Password: H = L * log2(94);  W = 2^H / (53.7 / k)
    R_base   = 53.7;           % H/s at k=1, m=1024 MiB
    L_chars  = 4:2:24;
    H_pwd    = L_chars * log2(94);
    W_base_pwd = (2 .^ H_pwd) / R_base;   % attacker time at k=1

    % k values and colours (blue → red gradient, 7 tiers)
    k_values = [1, 2, 4, 8, 16, 32, 64];
    colors   = [
        0.12  0.47  0.71;   % k=1   steel blue
        0.17  0.63  0.17;   % k=2   green
        1.00  0.50  0.05;   % k=4   orange
        0.84  0.15  0.16;   % k=8   red
        0.58  0.40  0.74;   % k=16  purple
        0.55  0.34  0.29;   % k=32  brown
        0.09  0.75  0.81;   % k=64  teal
    ];

    % ── Figure ────────────────────────────────────────────────────────────
    figure('Color', 'w', 'Position', [100, 100, 850, 950]);

    % ════════════════════════════════════════════════════════════════
    %  SUBPLOT 1 — SPATIAL SECURITY
    % ════════════════════════════════════════════════════════════════
    subplot(2, 1, 1);
    hold on;

    X_MIN = 1e8;   X_MAX = 1e70;
    plot_zones(X_MIN, X_MAX, T_Human, T_BIP39, 5.5);

    h = gobjects(length(k_values), 1);
    for i = 1:length(k_values)
        k = k_values(i);
        W_geo = W_base_spatial * k;        % shift entire curve by k

        h(i) = semilogx(W_geo, n_points, '-o', ...
            'LineWidth', 2.2, ...
            'Color',           colors(i, :), ...
            'MarkerFaceColor', colors(i, :), ...
            'MarkerSize', 7,   ...
            'DisplayName', sprintf('k = %d', k));
    end

    % Annotate crossing: n=3 already in Super Secure at k=1
    xline(T_BIP39, '--k', 'LineWidth', 1.2, 'HandleVisibility', 'off');

    ylabel('Spatial Points (n)', 'FontSize', 12, 'FontWeight', 'bold');
    title({'A)  KDF Chaining Depth: Spatial Security Spectrum', ...
           '(fixed m = 1{,}024 MiB,  R^{(1)} = 53.7 H/s)'}, ...
           'FontSize', 12);
    xlim([X_MIN X_MAX]);  ylim([0.5 5.5]);  yticks(1:5);
    set(gca, 'XScale', 'log', 'Layer', 'top', 'FontSize', 11);
    grid on;
    legend(h, 'Location', 'west', 'FontSize', 10);

    % ════════════════════════════════════════════════════════════════
    %  SUBPLOT 2 — LINGUISTIC SECURITY
    % ════════════════════════════════════════════════════════════════
    subplot(2, 1, 2);
    hold on;
    plot_zones(X_MIN, X_MAX, T_Human, T_BIP39, 26);

    for i = 1:length(k_values)
        k = k_values(i);
        W_pwd = W_base_pwd * k;

        semilogx(W_pwd, L_chars, '-s', ...
            'LineWidth', 2.2, ...
            'Color',           colors(i, :), ...
            'MarkerFaceColor', colors(i, :), ...
            'MarkerSize', 7,   ...
            'DisplayName', sprintf('k = %d', k));
    end

    xline(T_BIP39, '--k', 'LineWidth', 1.2, 'HandleVisibility', 'off');

    ylabel('Password Length (chars)', 'FontSize', 12, 'FontWeight', 'bold');
    xlabel('Attacker Work Factor  W  (seconds, log_{10} scale)', ...
           'FontSize', 12, 'FontWeight', 'bold');
    title({'B)  KDF Chaining Depth: Linguistic Security Spectrum', ...
           '(fixed m = 1{,}024 MiB,  R^{(1)} = 53.7 H/s)'}, ...
           'FontSize', 12);
    xlim([X_MIN X_MAX]);  ylim([2 26]);
    set(gca, 'XScale', 'log', 'Layer', 'top', 'FontSize', 11);
    grid on;

    % ── Export ────────────────────────────────────────────────────────────
    exportgraphics(gcf, 'KChain_Spectrum.pdf', 'ContentType', 'vector');
    fprintf('Saved: KChain_Spectrum.pdf\n');
    fprintf('\n--- Spatial W values (m=1024 MiB) ---\n');
    SEC_YR = 365.25 * 86400;
    for i = 1:length(k_values)
        k = k_values(i);
        fprintf('  k=%2d:  n=1 %.2e s   n=2 %.2e s   n=3 %.2e s\n', ...
            k, W_base_spatial(1)*k, W_base_spatial(2)*k, W_base_spatial(3)*k);
    end
end

% ── Helper: draw security zone background ────────────────────────────────
function plot_zones(xmin, xmax, t1, t2, ymax)
    patch([xmin t1  t1  xmin], [0 0 ymax ymax], ...
          [1 0.95 0.95], 'EdgeColor', 'none', 'HandleVisibility', 'off');
    patch([t1   t2  t2  t1  ], [0 0 ymax ymax], ...
          [1 1 0.9],   'EdgeColor', 'none', 'HandleVisibility', 'off');
    patch([t2   xmax xmax t2], [0 0 ymax ymax], ...
          [0.9 1 0.9], 'EdgeColor', 'none', 'HandleVisibility', 'off');

    text(3e9,  ymax*0.88, 'INSECURE',         'Color', [0.7 0 0],   'FontSize', 9, 'FontWeight', 'bold');
    text(1e21, ymax*0.88, 'HUMAN-SCALE SECURE','Color', [0.6 0.4 0], 'FontSize', 9, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
    text(1e46, ymax*0.88, 'SUPER SECURE (BIP-39)', 'Color', [0 0.5 0], 'FontSize', 9, 'FontWeight', 'bold');
end
