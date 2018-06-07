function out = ifthen(condition, A, B)
%IFTHEN Simple if/then/else conditional
%
% out = ifthen(condition, A, B)
%
% If condition is true, returns A, else returns B. This is useful for concisely
% expressing in-line alternatives.
%
% This is similar to the C "condition ? A : B" expression, except that A and B
% are eagerly evaluated; there is no short-circuiting.
%
% Returns either A or B.

if condition
    out = A;
else
    out = B;
end