function [vectors] = extractResponseVectors(image)

    function [bank] = gaborFilterBank(S, K)
        tpi = 2 * pi;

        W = 0.52;
        Uh = 0.4;
        Ul = 0.1;
        a = (Uh / Ul) ^ (1 / (S - 1));
        alpha = (a + 1) / (a - 1);
        sigma_x = (1 / tpi) * alpha * sqrt(2 * log(2)) / Uh;
        sigma_y = (1 / tpi) / (tan(pi / (2 * K)) / tpi * sqrt(alpha^2 - 1) / sigma_x);
        bound = 19;

        bank = cell(S, K);
        for m = 0 : S - 1
            for n = 0 : K - 1
                theta = n * pi / K;
                [x, y] = meshgrid(-bound:bound, -bound:bound);
                xp = a^(-m) * (x .* cos(theta) + y .* sin(theta));
                yp = a^(-m) * (-x .* sin(theta) + y .* cos(theta));
                gmn = a^(-m) / (tpi * sigma_x * sigma_y) * exp(-0.5 * (xp.^2 / sigma_x^2 + yp.^2 / sigma_y^2) + 1i * tpi * W .* xp);
                bank{m + 1, n + 1} = gmn;
            end
        end
    end

    S = 10;
    K = 10;
    bank = gaborFilterBank(S, K);
    vectors = zeros(numel(image), S * K);

    for s = 1 : S
        for k = 1 : K
            filtered = abs(imfilter(double(image), bank{s, k}));
            vectors(:, (s - 1) * K + k) = filtered(:);
        end
    end
end
