import os
import re
import shutil
import argparse
from collections import defaultdict

# Define regex patterns to match module and instance declarations
# Matches module declarations like `module my_module;`
verilog_module_pattern = re.compile(r'\bmodule\s+(\w+)\b')

# Matches instances like `my_module instance_name ( .clk(clk), .rst(rst) );`
# and instances with parameters like `module #( .PARAM0(VALUE0), .PARAM1(VALUE1)) my_module instance_name ( .clk(clk), .rst(rst) );`
verilog_instance_pattern = re.compile(r'\b(\w+)\s*(#\s*\(.*?\))?\s+(\w+)\s*\(')

# Function to extract modules and instances from a file
def extract_modules_and_instances(file_content):
    modules = set()
    instances = defaultdict(list)

    # Find all module declarations in the file
    module_matches = verilog_module_pattern.findall(file_content)
    # Find all instance declarations in the file
    instance_matches = verilog_instance_pattern.findall(file_content)

    for module in module_matches:
        modules.add(module)
    
    for instance in instance_matches:
        module_type, _, instance_name = instance
        instances[instance_name].append(module_type)

    return modules, instances

# Function to find all modules in the hierarchy
def find_all_modules(top_module, instances):
    to_explore = [top_module]
    explored = set()

    while to_explore:
        current = to_explore.pop()
        if current not in explored:
            explored.add(current)
            to_explore.extend(instances.get(current, []))
    
    return explored

# Main function to filter files
def filter_files(file_paths, top_module):
    all_modules = set()
    all_instances = defaultdict(list)
    file_module_map = {}

    top_module_defined = False

    # Step 1: Parse files
    for file_path in file_paths:
        with open(file_path, 'r') as file:
            content = file.read()
        
        modules, instances = extract_modules_and_instances(content)
        all_modules.update(modules)
        for key, value in instances.items():
            all_instances[key].extend(value)
        
        for module in modules:
            file_module_map[module] = file_path
            if module == top_module:
                top_module_defined = True
    
    # Check if top module is defined
    if not top_module_defined:
        raise ValueError(f"Top module '{top_module}' is not defined in any of the provided files.")

    # Step 2: Build hierarchy
    hierarchy_modules = find_all_modules(top_module, all_instances)

    # Step 3: Filter files
    filtered_files = set(file_module_map[module] for module in hierarchy_modules if module in file_module_map)

    return list(filtered_files)

def remove_common_path(file_paths):
    # Find the common path
    common_path = os.path.commonpath(file_paths)
    
    # Get the last common directory
    last_common_directory = os.path.basename(common_path)
    
    # Iterate over each file path and remove the common path
    updated_paths = []
    for path in file_paths:
        relative_path = os.path.relpath(path, common_path)
        updated_path = os.path.join(last_common_directory, relative_path)
        updated_paths.append(updated_path)
    
    return updated_paths

def main():
    parser = argparse.ArgumentParser(description="Filter RTL files based on module hierarchy.")
    parser.add_argument('--top', help='Top module name')
    parser.add_argument('--path', help='Root path where files will be copied')
    parser.add_argument('--list-files', action="store_true", help="Don't generate files, but instead just list the files that will be generated")
    # parser.add_argument('--', required=True, help='Output file path')
    parser.add_argument('files', metavar='F', type=str, nargs='+', help='List of RTL file paths')

    args = parser.parse_args()

    try:
        # If a top is given parse the files
        if args.top is not None:
            files = filter_files(args.files, args.top)
        else:
            files = args.files

        # Remove common path of the files
        files_striped = remove_common_path(files)
        # Get absolute path of the dst directory
        abs_path = os.path.abspath(args.path)
        # Change file paths to dst directory
        for f_dst in files_striped:
            files_dst = abs_path + '/' + f_dst

        # Only print the files if argument is passed
        if args.list_files:
            print(*files_dst)
        else:
            file_list_path = abs_path + '/file_list.txt'
            # Check if the file list exist, otherwise create it
            os.makedirs(os.path.dirname(file_list_path), exist_ok=True)
            # Write the files to the file list
            with open(abs_path + '/file_list.txt', 'w') as outfile:
                for f_src, f_dst in zip(files, files_dst):
                    # Write the path to the list of path file
                    outfile.write(f_dst + '\n')
                    # Copy the file
                    # shutil.copyfile(f_src, f_dst)

                # Add empty line at the end of the file
                outfile.write('\n')
            print(f"Filtered file list written to {file_list_path}")
    except ValueError as e:
        print(e)

if __name__ == "__main__":
    main()
