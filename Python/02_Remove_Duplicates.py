def remove_duplicates(text):
 
    result = ""
    
    for char in text:
        if char not in result:
            result += char
    
    return result


if __name__ == "__main__":

    user_input = input("Enter a string: ")
    
    unique_string = remove_duplicates(user_input)
    
    print(f"Original string: '{user_input}'")
    print(f"Unique string:   '{unique_string}'")
    print(f"Characters removed: {len(user_input) - len(unique_string)}")
