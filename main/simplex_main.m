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
 % Main control for simplex two-phase algorithm.
%%
function x_B = simplex_main(A, b, c, v)
  clc;
  
  [m, n] = size(A);
  p = size(c, 2);
  mPn = m + n; % mPn = m + n
  
  if v
    fprintf('------- Simplex Two-phase Algorithm -------\n');
  end
  
  
  
  % ------- Phase 1 ------- %
  if v
    fprintf('\n\n\n');
    fprintf('----- Phase 1 -----\n');
  end
  
  
  % Free Refill
  [B, N, c_B, c_N, J] = free_refill(A);
  
  
  % Jumper
  [B, N, J, x_B] = simplex_core(B, N, b, c_B, c_N, J, v);
  
  
  % Clean Up
  c_B = [ ];
  for i = 1:1:m
    if J(i) > p
      if(J(i) > n  &&  x_B(i) ~= 0) % Test artificial variable for feasibility
        if v
          fprintf('\n\n');
          msgbox('The original problem has no feasible solution.', 'Operation stopped', 'error');
        end
        return
      else
        c_B(i) = 0;
      end
    else
      c_B(i) = c(J(i));
    end
  end
  
  c_N = [ ];
  n_ = size(J, 2);  i = m + 1;  j = 1;
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
  
  
  
  
  
  % ------- Phase 2 ------- %
  if v
    fprintf('\n\n\n');
    fprintf('----- Phase 2 -----\n');
  end
  
  [B, N, J, x_B] = simplex_core(B, N, b, c_B, c_N, J, v);
  
  
  
  
  
  % Blob Plot
  x_ = [ zeros(1, p) ];
  
  i = 1;  j = 1;
  while(i <= m  &&  j <= p)
    if J(i) <= p
      x_(J(i)) = x_B(i);
      j = j + 1;
    end
    i = i + 1;
  end
  
  x_B = transpose(x_);
  
end
