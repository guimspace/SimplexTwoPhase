 %%
 % Recursively verify if V is an identity array.
%%
function [r k] = recursive_is_identity_column(V, index, t)
  i = index;
  while(i > 0  &&  V(i) == 0)
    i = i - 1;
  end
  
  k = i;
  if(i == 0)
    r = t;
  elseif(V(i) ~= 1)
    r = false;
  else
    if(t)
      r = false;
    else
      i = i - 1;
      r = foo_search(V, i, true);
    end
  end
end
