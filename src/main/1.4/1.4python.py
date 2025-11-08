def get_num(prompt, want_int=False):
    while True:
        s = input(prompt).strip()
        if not s:
            print("Invalid. Please enter a number.")
            continue
        try:
            x = float(s)
            return int(x) if want_int else x
        except ValueError:
            print("Invalid. Please enter an integer number only.\n" if want_int
                  else "Invalid. Please enter a numeric value (e.g., 1.5, 2, 0.25).\n")

def read_clock_cycle_seconds():
    v = get_num("Enter clock cycle time value (e.g., 2.5): ")
    units = {"s":1, "ms":1e-3, "us":1e-6, "ns":1e-9, "ps":1e-12}
    while True:
        unit = input("Enter unit (s / ms / us / ns / ps): ").strip().lower()
        if unit in units:
            return v * units[unit]
        print("Invalid Unit. Please enter one of: s, ms, us, ns, ps.\n")

def choose_output():
    while True:
        print("\nSelect output:")
        print("  1) Total clock cycles")
        print("  2) Total execution time")
        print("  3) Both")
        choice = input("Enter option number (1/2/3): ").strip()
        if choice in {"1", "2", "3"}:
            return int(choice)
        print("Invalid input. Please enter 1, 2, or 3.\n")

def main():
    print("=== Execution Time Calculator ===")
    n = get_num("Enter number of instruction types: ", want_int=True)

    total_cycles = 0.0
    for i in range(n):
        count = get_num(f"Enter instruction count for type {i+1}: ", want_int=True)
        cpi   = get_num(f"Enter CPI for type {i+1}: ")
        total_cycles += count * cpi

    print("\nNow enter the clock cycle time:")
    cycle_time = read_clock_cycle_seconds()
    exec_time  = total_cycles * cycle_time

    # Let user choose what to display
    option = choose_output()

    print("\n--- Results ---")
    if option in (1, 3):
        print(f"Total clock cycles = {total_cycles:,.0f}")

    if option in (2, 3):
        t = exec_time
        if   t >= 1:     print(f"Total execution time = {t:.6f} s")
        elif t >= 1e-3:  print(f"Total execution time = {t*1e3:.6f} ms")
        elif t >= 1e-6:  print(f"Total execution time = {t*1e6:.6f} µs")
        elif t >= 1e-9:  print(f"Total execution time = {t*1e9:.6f} ns")
        else:            print(f"Total execution time = {t*1e12:.6f} ps")

if __name__ == "__main__":
    main()
