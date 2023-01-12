import sys
import unittest
from framework import AssemblyTest, print_coverage, _venus_default_args
from tools.check_hashes import check_hashes

"""
Coverage tests for project 2 is meant to make sure you understand
how to test RISC-V code based on function descriptions.
Before you attempt to write these tests, it might be helpful to read
unittests.py and framework.py.
Like project 1, you can see your coverage score by submitting to gradescope.
The coverage will be determined by how many lines of code your tests run,
so remember to test for the exceptions!
"""

"""
abs_loss
# =======================================================
# FUNCTION: Get the absolute difference of 2 int arrays,
#   store in the result array and compute the sum
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the length of the arrays
#   a3 (int*) is the pointer to the start of the result array

# Returns:
#   a0 (int)  is the sum of the absolute loss
# Exceptions:
# - If the length of the array is less than 1,
#   this function terminates the program with error code 36.
# =======================================================
"""


class TestAbsLoss(unittest.TestCase):
    def doTest(self, arr0, arr1, len, result, return_val, code=0):
        # load the test for abs_loss.s
        t = AssemblyTest(self, "../coverage-src/abs_loss.s")

        # load address of `array0` into register a0
        t.input_array("a0", t.array(arr0))
        # load address of `array1` into register a1
        t.input_array("a1", t.array(arr1))
        
        # set a2 to the length of the array
        t.input_scalar("a2", len)
        output_array = t.array([0] * len)
        t.input_array("a3", output_array)
        # call the `abs_loss` function
        t.call("abs_loss")
        if code == 0:
            # check that the result array contains the correct output
            t.check_array(output_array, result)
            # check that the register a0 contains the correct output
            t.check_scalar("a0", return_val)
        # generate the `assembly/TestAbsLoss_test_simple.s` file and run it through venus
        t.execute(code=code)

    # Add other test cases if neccesary
    # arr1 < arr2 and len = 1
    def test_length_1a(self):
        self.doTest(
            [1],
            [2],
            1,
            [1],
            1,
        )

    # arr1 > arr2 and len = 1
    def test_length_1b(self):
        self.doTest(
            [2],
            [1],
            1,
            [1],
            1,
        )

    # len = 0
    def test_length_0(self):
        self.doTest(
            [2],
            [1],
            0,
            [0],
            1,
            36
        )
    
    # len < 0
    def test_length_negative(self):
        self.doTest(
            [2],
            [1],
            -1,
            [1],
            1,
            36
        )

    # a normal test case
    def test_normal(self):
        self.doTest(
            [1, 2, 3, 4, 5, 6, 7, 8, 9],
            [1, 6, 1, 6, 1, 6, 1, 6, 1],
            9,
            [0, 4, 2, 2, 4, 0, 6, 2, 8],
            28,
        )

    @classmethod
    def tearDownClass(cls):
        print_coverage("abs_loss.s", verbose=False)


"""
squared_loss
# =======================================================
# FUNCTION: Get the squared difference of 2 int arrays,
#   store in the result array and compute the sum
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the length of the arrays
#   a3 (int*) is the pointer to the start of the result array

# Returns:
#   a0 (int)  is the sum of the squared loss
# Exceptions:
# - If the length of the array is less than 1,
#   this function terminates the program with error code 36.
# =======================================================
"""


class TestSquaredLoss(unittest.TestCase):
    def doTest(self, arr0, arr1, len, result, return_val, code=0):
        # load the test for abs_loss.s
        t = AssemblyTest(self, "../coverage-src/squared_loss.s")

        # load address of `array0` into register a0
        t.input_array("a0", t.array(arr0))
        # load address of `array1` into register a1
        t.input_array("a1", t.array(arr1))
        
        # set a2 to the length of the array
        t.input_scalar("a2", len)
        output_array = t.array([0] * len)
        t.input_array("a3", output_array)
        # call the `abs_loss` function
        t.call("squared_loss")

        if code == 0:
            # check that the result array contains the correct output
            t.check_array(output_array, result)
            # check that the register a0 contains the correct output
            t.check_scalar("a0", return_val)
        # generate the `assembly/TestAbsLoss_test_simple.s` file and run it through venus
        t.execute(code=code)

    # Add other test cases if neccesary
    # arr1 < arr2 and len = 1
    def test_length_1a(self):
        self.doTest(
            [1],
            [2],
            1,
            [1],
            1,
        )

    # arr1 > arr2 and len = 1
    def test_length_1b(self):
        self.doTest(
            [2],
            [1],
            1,
            [1],
            1,
        )

    # len = 0
    def test_length_0(self):
        self.doTest(
            [2],
            [1],
            0,
            [0],
            1,
            36
        )
    
    # len < 0
    def test_length_negative(self):
        self.doTest(
            [2],
            [1],
            -1,
            [1],
            1,
            36
        )

    # a normal test case
    def test_normal(self):
        self.doTest(
            [1, 2, 3, 4, 5, 6, 7, 8, 9],
            [1, 6, 1, 6, 1, 6, 1, 6, 1],
            9,
            [0, 16, 4, 4, 16, 0, 36, 4, 64],
            144,
        )

    @classmethod
    def tearDownClass(cls):
        print_coverage("squared_loss.s", verbose=False)


"""
zero_one_loss
# =======================================================
# FUNCTION: Generates a 0-1 classifer array inplace in the result array,
#  where result[i] = (arr0[i] == arr1[i])
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the length of the arrays
#   a3 (int*) is the pointer to the start of the result array

# Returns:
#   NONE
# Exceptions:
# - If the length of the array is less than 1,
#   this function terminates the program with error code 36.
# =======================================================
"""


class TestZeroOneLoss(unittest.TestCase):
    def doTest(self, arr0, arr1, len, result, code=0):
        # load the test for abs_loss.s
        t = AssemblyTest(self, "../coverage-src/zero_one_loss.s")

        # load address of `array0` into register a0
        t.input_array("a0", t.array(arr0))
        # load address of `array1` into register a1
        t.input_array("a1", t.array(arr1))
        
        # set a2 to the length of the array
        t.input_scalar("a2", len)
        output_array = t.array([0] * len)
        t.input_array("a3", output_array)
        # call the `abs_loss` function
        t.call("zero_one_loss")
        if code == 0:
            # check that the result array contains the correct output
            t.check_array(output_array, result)
        # check that the register a0 contains the correct output
        # generate the `assembly/TestAbsLoss_test_simple.s` file and run it through venus
        t.execute(code=code)

    # Add other test cases if neccesary
    # arr1 < arr2 and len = 1
    def test_length_1a(self):
        self.doTest(
            [1],
            [2],
            1,
            [0],
        )

    # arr1 > arr2 and len = 1
    def test_length_1b(self):
        self.doTest(
            [2],
            [1],
            1,
            [0],
        )

    # arr1 = arr2 and len = 1
    def test_length_1c(self):
        self.doTest(
            [1],
            [1],
            1,
            [1],
        )


    # len = 0
    def test_length_0(self):
        self.doTest(
            [2],
            [1],
            0,
            [0],
            36
        )
    
    # len < 0
    def test_length_negative(self):
        self.doTest(
            [2],
            [1],
            -1,
            [1],
            36
        )

    # a normal test case
    def test_normal(self):
        self.doTest(
            [1, 2, 3, 4, 5, 6, 7, 8, 9],
            [1, 6, 1, 6, 1, 6, 1, 6, 1],
            9,
            [1, 0, 0, 0, 0, 1, 0, 0, 0],
        )

    @classmethod
    def tearDownClass(cls):
        print_coverage("zero_one_loss.s", verbose=False)


"""
initialize_zero
# =======================================================
# FUNCTION: Initialize a zero array with the given length
# Arguments:
#   a0 (int) size of the array

# Returns:
#   a0 (int*)  is the pointer to the zero array
# Exceptions:
# - If the length of the array is less than 1,
#   this function terminates the program with error code 36.
# - If malloc fails, this function terminates the program with exit code 26.
# =======================================================
"""


class TestInitializeZero(unittest.TestCase):
    def doTest(self, len, result, code=0):
        t = AssemblyTest(self, "../coverage-src/initialize_zero.s")

        # input the length of the desired array
        t.input_scalar("a0", len)
        # call the `initialize_zero` function
        
        # check that the register a0 contains the correct array (hint: look at the check_array_pointer function in framework.py)
        t.call("initialize_zero")
        if code == 0:
            t.check_array_pointer("a0", result)
        t.execute(code=code)

    # Add other test cases if neccesary
    def test_length_0(self):
        self.doTest(
            0,
            [0],
            36
        )

    def test_length_positive(self):
        self.doTest(
            1,
            [0],
        )

    def test_length_negative(self):
        self.doTest(
            -1,
            [0],
            36
        )

    def test_normal(self):
        self.doTest(
            4,
            [0, 0, 0, 0],
        )


    # request too many space 
    def test_normal(self):
        self.doTest(
            0x7fffffff,
            [0],
            26
        )

    @classmethod
    def tearDownClass(cls):
        print_coverage("initialize_zero.s", verbose=False)


if __name__ == "__main__":
    split_idx = sys.argv.index("--")
    for arg in sys.argv[split_idx + 1 :]:
        _venus_default_args.append(arg)

    check_hashes()

    unittest.main(argv=sys.argv[:split_idx])
