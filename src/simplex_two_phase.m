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
 % Main control for simplex two-phase algorithm.
 %%
function [x z chk] = simplex_two_phase(A, b, c, v)
	if v
		fprintf("SimplexTwoPhase v2.0.0\n");
	end

	z = [ ];
	x = [ ];
	chk = [ ];

	[m, n] = size(A);
	p = size(c, 2);
	mPn = m + n; % mPn = m + n

	% ------- Phase 1 ------- %
	if v
		fprintf("Phase 1\n");
	end


	% Free Refill
	[B, N, c_B, c_N, J, hasArtificial] = free_refill(A);

	if hasArtificial
		% Jumper
		[B, N, J, x_B, chk] = simplex_algorithm(B, N, b, c_B, c_N, J, v);


		% Clean Up
		c_B = [ ];
		for i = 1:1:m
			if J(i) > p
				if(J(i) > n  &&  x_B(i) ~= 0) % Test artificial variable for feasibility
					chk = -1;
					fprintf("Empty Feasible Region\n");
					fprintf("- The system of equations and/or inequalities defining the feasible region is inconsistent.\n");
					fprintf("No optimal solution exists.\n");
					return
				else
					c_B(i) = 0;
				end
			else
				c_B(i) = c(J(i));
			end
		end

		c_N = [ ];
		n_ = size(J, 2);
		i = m + 1;
		j = 1;

		while i <= n_
			if J(i) > n % Test for artificial variable
				N(:, j) = [ ];
				J(i) = [ ];
				n_ = n_ - 1;
			else
				if J(i) > p % Test for slack variable
					c_N(j) = 0;
				else
					c_N(j) = c(J(i));
				end
				i = i + 1;
				j = j + 1;
			end
		end
	else
		if v
			fprintf("Skip: starting solution is trivial.\n");
		end

		for i = 1:1:m
			if J(i) > p
				c_B(i) = 0;
			else
				c_B(i) = c(J(i));
			end
		end

		n_ = size(J, 2);
		i = m + 1;
		j = 1;

		while i <= n_
			if J(i) > p % Test for slack variable
				c_N(j) = 0;
			else
				c_N(j) = c(J(i));
			end

			i = i + 1;
			j = j + 1;
		end
	end

	% ------- Phase 2 ------- %
	if v
		fprintf("Phase 2\n");
	end

	[B, N, J, x_B, chk] = simplex_algorithm(B, N, b, c_B, c_N, J, v);

	% Blob Plot
	if(chk == 0 || chk == 1)
		x = [ zeros(1, p) ];
		i = 1;
		j = 1;

		while(i <= m  &&  j <= p)
			if J(i) <= p
				x(J(i)) = x_B(i);
				j = j + 1;
			end

			i = i + 1;
		end

		x = transpose(x);
		x_ = sprintf("%d ", x);
		z = c * x;
	end

	switch chk
		case 0
			fprintf("Unique Optimal Solution\n");
			fprintf("Objectve value\n  z = %f\n", z);
			fprintf("Solution\n  x^T = [ %s]\n", x_);
		case 1
			fprintf("Alternative Optimal Solutions\n");
			fprintf("- Optimal solution set is unbounded.\n");
			fprintf("Objective value\n  z = %f\n", z);
			fprintf("Solution\n  x^T = [ %s]\n", x_);
		case 10
			fprintf("Unbounded Optimal Objective Value\n");
			fprintf("- The problem is infeasible, inconsistent, or with an empty feasible region.\n");
			fprintf("No optimal solution exists.\n");
	end
	fprintf("\n");
end
