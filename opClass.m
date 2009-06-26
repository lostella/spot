%OPCLASS   Wrapper for classes
%
%   OPCLASS(M,N,OBJ,CFLAG,LINFLAG) creates an M by N wrapper operator
%   for the class instance OBJ. The only requirement on OBJ is that it
%   implements the `mtimes' method. Optional arguments CFLAG and LINFLAG
%   indicate whether the class implements a complex or real operator and
%   whether it is linear or not. By default these fields are set to
%   CFLAG=0, LINFLAG=1.

%   Copyright 2009, Ewout van den Berg and Michael P. Friedlander
%   http://www.cs.ubc.ca/labs/scl/sparco
%   $Id: opClass.m 16 2008-08-26 01:19:51Z ewout78 $

classdef opClass < opSpot

   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Properties
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties (SetAccess = private)
        obj = {}; % Underlying class
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Methods
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods

       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       % Constructor
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function op = opClass(m,n,obj,cflag,linflag)

           if nargin < 5, linflag = 1; end;
           if nargin < 4, cflag   = 0; end;

           if nargin < 3
              error('opClass requires at least three parameters.');
           end

           if ~isposintscalar(m) || ~isposintscalar(n)
              error('Dimensions of operator must be positive integers.');
           end
           
           if ~isobject(obj)
              error('Input argument must be a class object.');
           end

           if ~(ismethod(obj,'mtimes') && ismethod(obj,'ctranspose'))
              error('The class object must proved the `mtimes'' and `ctranspose'' methods.');
           end

          % Create object
          description = ['Class:',class(obj)];
          op = op@opSpot(description, m, n);
          op.cflag      = cflag;
          op.linear     = linflag;
          op.precedence = 1;
          op.obj        = obj;
       end

    end % Methods


    methods ( Access = protected )
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       % Multiply
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function y = multiply(op,x,mode)
           if mode == 1
              y = op.obj * x;
           else
              y = op.obj' * x;
           end
        end
    end % methods
   
end
    

