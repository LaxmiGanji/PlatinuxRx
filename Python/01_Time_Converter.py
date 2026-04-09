def convert_minutes(total_minutes):
    """
    Converts integer minutes into 'X hrs Y minutes' format.
    """
    try:
        total_minutes = int(total_minutes)
    except ValueError:
        return "Invalid input. Please provide an integer."
        
    hours = total_minutes // 60
    minutes = total_minutes % 60
    
    return f"{hours} hrs {minutes} minutes"

if __name__ == "__main__":
    # Test cases
    test_values = [130, 60, 45, 0, 1500]
    for val in test_values:
        print(f"{val} minutes = {convert_minutes(val)}")
