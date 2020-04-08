%	MIT License
%
%	Copyright (c) 2017 Guilherme Tadashi Maeoka
%	https://github.com/guimspace/SimplexTwoPhase
%
%	Permission is hereby granted, free of charge, to any person obtaining a copy
%	of this software and associated documentation files (the "Software"), to deal
%	in the Software without restriction, including without limitation the rights
%	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
%	copies of the Software, and to permit persons to whom the Software is
%	furnished to do so, subject to the following conditions:
%
%	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
%	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
%	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
%	SOFTWARE.

%%
 % Dantzig's Simplex Algorithm
 %%
function [B, N, J, x_B, chk] = simplex_algorithm(B, N, b, c_B, c_N, J, v)
	chk = 0;
	[m, n] = size(N);

	k = 1;
	while true
		% Basic feasible solution
		x_B = B \ b;

		% Simplex multiplier
		w = c_B / B;

		% Pricing operation
		zMc = [ ]; % zMc = z_k - c_k = wa_j - c_j
		for i = 1:1:n
			zMc(i) = w * N(:, i) - c_N(i);
		end

		[c_k k_in] = max(zMc);

		if c_k <= 0 % Test for optimality
			if v
				fprintf("Simplex complete\n");

				if c_k == 0
					chk = 1;
					fprintf("Alternative optimal solutions found.\n");
				else
					fprintf("Optimal solution found.\n");
				end
			end
			return
		else
			y = B \ N(:, k_in); % Simplex ray

			r = [ ];  j = 1;
			for i = 1:1:m
				if y(i) > 0
					r(j, 1) = x_B(i) / y(i); % Ratio
					r(j, 2) = i;
					j = j + 1;
				end
			end


			% Test unboundness
			if isempty(r)
				chk = 10;
				x_B = [ ];
				if v
					fprintf("Simplex stopped\n");
					fprintf("Unbounded optimal objective value.\n");
				end
				return
			else
				[r_k, i] = min(r(:, 1)); % Minimum ratio test
				k_out = r(i, 2);
			end
		end



		% Switch columns
		if v
			fprintf("%d.  z = %f;  %d <-> %d\n", k, c_B*x_B, J(k_out), J(m+k_in));
		end

		% B <-> N
		t_ = B(:, k_out);
		B(:, k_out) = N(:, k_in);
		N(:, k_in) = t_;

		% c_B <-> c_N
		t_ = c_B(:, k_out);
		c_B(:, k_out) = c_N(:, k_in);
		c_N(:, k_in) = t_;

		% J_B <-> J_N
		t_ = J(k_out);
		J(k_out) = J(m+k_in);
		J(m+k_in) = t_;

		k = k + 1;
	end
end
