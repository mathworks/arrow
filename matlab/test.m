function test()
% Test runner for MATLAB Library for Apache Arrow

% Licensed to the Apache Software Foundation (ASF) under one
% or more contributor license agreements.  See the NOTICE file
% distributed with this work for additional information
% regarding copyright ownership.  The ASF licenses this file
% to you under the Apache License, Version 2.0 (the
% "License"); you may not use this file except in compliance
% with the License.  You may obtain a copy of the License at
%
%   http://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing,
% software distributed under the License is distributed on an
% "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
% KIND, either express or implied.  See the License for the
% specific language governing permissions and limitations
% under the License.

srcFolder = fullfile(pwd, 'src');
arrowFolder = fullfile(pwd, 'lib', 'arrow');

mex(fullfile(srcFolder, 'featherreadmex.cc'), fullfile(srcFolder, 'feather_reader.cc'), ...
    ['-L' fullfile(arrowFolder, 'lib')], '-larrow', ['-I', fullfile(arrowFolder, 'include')], ...
    '-R2018a', '-v');

suite = matlab.unittest.TestSuite.fromFolder('test');
results = suite.run();
assert(all(~[results.Failed]));
end
