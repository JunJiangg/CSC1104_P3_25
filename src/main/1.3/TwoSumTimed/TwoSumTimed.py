"""
Benchmark version of TwoSum - measures only algorithm performance
No user interaction - runs automated timing tests
"""

import time

def find_two_sum(numbers, target):
    """Find two numbers that sum to target"""
    n = len(numbers)
    for i in range(n - 1):
        for j in range(i + 1, n):
            if numbers[i] + numbers[j] == target:
                return (numbers[i], numbers[j], i, j)
    return None

def run_single_test():
    """Run single execution with timing"""
    test_array = [10, 15, 3, 7, 22, 8, 12, 5]
    target = 18
    
    print("\n=== Single Execution Test ===")
    print(f"Array: {test_array}")
    print(f"Target: {target}\n")
    
    start_time = time.perf_counter()
    result = find_two_sum(test_array, target)
    end_time = time.perf_counter()
    
    execution_time = end_time - start_time
    time_microseconds = execution_time * 1000000
    
    if result:
        num1, num2, idx1, idx2 = result
        print(f"Result: Found {num1} + {num2} = {target}")
    else:
        print("Result: No pair found")
    
    print(f"Execution time: {execution_time:.9f} seconds ({time_microseconds:.3f} microseconds)")

def run_benchmark():
    """Run multiple iterations for accurate timing"""
    test_array = [10, 15, 3, 7, 22, 8, 12, 5]
    target = 18
    iterations = 100000
    
    print("\n=== Benchmark Test (Multiple Iterations) ===")
    print(f"Running {iterations} iterations...")
    
    start_time = time.perf_counter()
    
    for _ in range(iterations):
        find_two_sum(test_array, target)
    
    end_time = time.perf_counter()
    
    total_time = end_time - start_time
    avg_time = total_time / iterations
    avg_microseconds = avg_time * 1000000
    
    print(f"Total time: {total_time:.6f} seconds")
    print(f"Average per iteration: {avg_time:.9f} seconds ({avg_microseconds:.3f} microseconds)")
    print(f"Iterations per second: {iterations / total_time:.0f}\n")

def main():
    print("\n╔════════════════════════════════════════╗")
    print("║  Two Sum - Python Performance Benchmark║")
    print("╚════════════════════════════════════════╝")
    
    run_single_test()
    run_benchmark()

if __name__ == "__main__":
    main()

"""
Execution: python3 TwoSum_benchmark.py
"""