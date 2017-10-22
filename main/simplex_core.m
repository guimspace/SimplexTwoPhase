%	MIT License
%
%	Copyright (c) 2017 Guilherme Tadashi Maeoka
% https://github.com/g117126unicamp/SimplexTwoPhase
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
function [B, N, J, x_B] = simplex_core(B, N, b, c_B, c_N, J, v)

  N_size = size(N);


  k = 1;
  while true
	  % Basic feasible solution
	  x_B = B\b;
	  
	  
	  % Simplex multiplier
	  w = c_B/B;
	  
	  
	  % Pricing operation
	  zMc = [ ]; % zMc = z_k - c_k = wa_j - c_j
	  for i = 1:1:N_size(2)
		  zMc(i) = w*N(:, i) - c_N(i);
	  end
    
	  
	  % Test for optimality
	  [c_k k_in] = max(zMc);
	  
	  if(c_k <= 0)
	    if(v)
	      fprintf('Optimal solution found.\n')
	    end
	    return
	  else
		  y = B\N(:, k_in); % Simplex ray
		  
		  r = [ ];  j = 1;
		  for i = 1:1:N_size(1)
		    if(y(i) > 0)
		      r(j,1) = x_B(i) / y(i); % Ratio
		      r(j,2) = i;
		      j = j + 1;
		    end
		  end
		  
		  
		  if( isempty(r) ) % Test unboundness
		    if(v)
		      fprintf('Optimal solution is unbounded.\n')
		    end
		    return
	    else
	      [r_k, i] = min(r(:,1)); % Minimum ratio test
	      k_out = r(i,2);
	    end
	  end
	  
	  
	  
	  % Switch columns
	  if(v)
	    fprintf('%d:  z = %f;  %d <-> %d\n', k, c_B*x_B, J(k_out), J(N_size(1)+k_in))
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
	  J(k_out) = J(N_size(1)+k_in);
	  J(N_size(1)+k_in) = t_;
	  
	  k = k+1;
  end
end
