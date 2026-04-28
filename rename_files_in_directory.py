#!/usr/bin/python3
# Removes a portion of a file name from files within a defined directory.

import os

def main():
    # Get directory from user
    directory = input("Enter the full path to the directory containing the files: ").strip()

    # Check if directory exists
    if not os.path.exists(directory):
        print(f"Error: The directory '{directory}' does not exist. Please try again.")
        return

    # Get substring to replace from user
    substring = input("Enter the substring you want to remove from the filenames: ").strip()
    if not substring:
        print("Error: You must provide a substring to remove.")
        return

    print("\nStarting Rename Job...")
    renamed_files = 0

    try:
        # Iterate through files in the directory
        for file_name in os.listdir(directory):
            old_path = os.path.join(directory, file_name)
            # Skip directories; only process files
            if os.path.isfile(old_path):
                new_file_name = file_name.replace(substring, "").lower()
                new_path = os.path.join(directory, new_file_name)
                
                # Check for potential conflicts
                if old_path != new_path and os.path.exists(new_path):
                    print(f"Warning: Cannot rename '{file_name}' to '{new_file_name}' (file already exists).")
                    continue

                # Rename the file
                os.rename(old_path, new_path)
                renamed_files += 1

        print(f"Completed Rename Job Successfully. {renamed_files} files were renamed.")

    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    main()
