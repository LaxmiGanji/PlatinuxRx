def convert_minutes(total_minutes):

    try:
        total_minutes = int(total_minutes)
    except ValueError:
        return "Invalid input. Please provide an integer."
    
    if total_minutes < 0:
        return "Invalid input. Minutes cannot be negative."
    
    hours = total_minutes // 60
    minutes = total_minutes % 60
    
    hour_text = "hr" if hours == 1 else "hrs"
    minute_text = "minute" if minutes == 1 else "minutes"
    
    if hours == 0 and minutes == 0:
        return "0 minutes"
    elif hours == 0:
        return f"{minutes} {minute_text}"
    elif minutes == 0:
        return f"{hours} {hour_text}"
    else:
        return f"{hours} {hour_text} {minutes} {minute_text}"


if __name__ == "__main__":
    user_input = input("Enter minutes: ")
    
    result = convert_minutes(user_input)
    print(f"\nResult: {result}")