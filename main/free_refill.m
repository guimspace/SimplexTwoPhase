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
 % Harvest identiy columns from A to B and fill with artificial variables.
%%
function [B N c_B c_N J] = free_refill(A)
  [m n] = size(A);
  mPn = m + n;
  
  B = eye(m);
  N = [ ];
  c_B = zeros(1, m);
  c_N = zeros(1, n);
  J = [ zeros(1, mPn) ];
  
  
  for j = n:-1:1
    i = m;
    [r k] = recursive_is_identity_array(transpose(A(:, j)), i, false);
    
    if(r  &&  ~J(k))
      J(k) = j;
    else
      J(m+j) = j;
      N = [A(:, j) N];
    end
  end
  
  k = n + 1;
  for i = 1:1:m
    if ~J(i)
      c_B(i) = 1;
      J(i) = k;
      k = k + 1;
    end
  end
  
  n_ = mPn;  i = i + 1;
  while i <= n_
    if ~J(i)
      J(i) = [ ];
      n_ = n_ - 1;
    else
      i = i + 1;
    end
  end
  
  c_N = zeros(1, n_);
end