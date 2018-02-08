function dist = flipper(skelldef,q, x,y)
disp('hello')
%%%% this function needs skelldef period
%i need to know if it is postion or velocity or all or something custom

% or i can just know q?


part = 16:30;
x_f = x;
x_f(part) = -x(part);
dist = min([pdist2(x,y) pdist2(x_f,y)]);
end
