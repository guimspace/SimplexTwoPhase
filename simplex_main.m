%	MIT License
%
%	Copyright (c) 2017 Guilherme Tadashi Maeoka
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
  
  A_size = size(A);
  c_size = size(c);
  mPn = A_size(1) + A_size(2); % mPn = m + n
  
  if(v)
    fprintf('------- Simplex Two-phase Algorithm -------\n');
    A
    b
    c
  end
  
  
  
  % ------- Phase 1 ------- %
  if(v)
    fprintf('\n\n\n');
    fprintf('----- Phase 1 -----\n');
  end
  
  % Free Refill
  B = eye(A_size(1));
  c_B = ones(1, A_size(1));
  c_N = zeros(1, A_size(2));
  J = [(A_size(2)+1):1:mPn 1:1:A_size(2)];
  
  if(v)
    B
    N = A
    c_B
    c_N
    J
  end
  
  [B, N, J, x_B] = simplex_core(B, A, b, c_B, c_N, J, v);
  
  
  %Clean Up
  c_B = [ ];
  for i = 1:1:A_size(1)
    if(J(i) > c_size(2))
      c_B(i) = 0;
    else
      c_B(i) = c(J(i));
    end
  end
  
  c_N = [ ];
  i = A_size(1) + 1;  j = 1;  k = 0;
  while(i <= mPn - k)
    if(J(i) > A_size(2)) % Test for artificial variable
      N(:,j) = [ ];
      J(i) = [ ];
      k = k + 1;
    else
      if(J(i) > c_size(2)) % Test for slack variable
        c_N(j) = 0;
      else
        c_N(j) = c(J(i));
      end
      i = i + 1;
      j = j + 1;
    end
  end
  
  if(v)
    B
    N
    c_B
    c_N
    J
  end
  
  
  
  
  
  % ------- Phase 2 ------- %
  if(v)
    fprintf('\n\n\n');
    fprintf('----- Phase 2 -----\n');
  end
  
  % ...
  
end
