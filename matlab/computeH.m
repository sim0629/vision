function [H] = computeH(t1, t2)
    N = size(t1, 2);
    assert(N == size(t2, 2));

    B = zeros(18, N);
    for i = 1 : N
        xi  = t1(1, i); yi  = t1(2, i);
        xip = t2(1, i); yip = t2(2, i);
        xy1i = [xi, yi, 1];
        B(:, i) = [xy1i, 0, 0, 0, -xip .* xy1i, 0, 0, 0, xy1i, -yip .* xy1i];
    end
    At = reshape(B, 9, 2 * N);
    A = At';

    [V, ~] = eigs(At * A, 1, 'sm');
    H = reshape(V, 3, 3)';
end
