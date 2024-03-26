import toml
import yaml
import sys

def convert_toml_to_yaml(toml_file, yaml_file):
    # Load the TOML file
    with open(toml_file, 'r') as tf:
        toml_data = toml.load(tf)

    # Convert and save the data to a YAML file
    with open(yaml_file, 'w') as yf:
        yaml.dump(toml_data, yf, sort_keys=False, default_flow_style=False)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python convert.py input.toml output.yaml")
    else:
        convert_toml_to_yaml(sys.argv[1], sys.argv[2])

