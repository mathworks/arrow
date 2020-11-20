classdef tdummytest < matlab.unittest.TestCase
    % Dummy test to check Travis CI operation

    methods(Test)

        function DummyTest(testCase)
        %This is a dummy test to check CI operations 
            disp('dummy test');
            testCase.verifyTrue(true);
        end

    end
    
end
