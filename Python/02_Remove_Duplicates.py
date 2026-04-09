def remove_duplicates(input_string):
    """
    Takes a string and removes duplicate characters using a loop.
    """
    result = ""
    for char in input_string:
        if char not in result:
            result += char
            
    return result

if __name__ == "__main__":
    # Test cases
    test_strings = ["hello world", "programming", "aabbccdd", "abcdef", "Google"]
    for s in test_strings:
        print(f"Original: '{s}' -> No Duplicates: '{remove_duplicates(s)}'")
