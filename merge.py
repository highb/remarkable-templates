# Given a base templates.json file, and another template.json file, merge them
# together, updating any existing templates with matching "name" fields with the 
# new data from the additional template file.
#
# Format of the files is as follows:
# {
#     "templates": [
#         {
#             "name": "Daily Plan v1",
#             "filename": "noteto-template-daily-plan-v1",
#             "hasVariant": false,
#             "iconCode": "\ue9dc", # Note that this is an ESCAPED unicode character
#             "categories": [
#                 "Life/organize"
#             ]
#         },
#         {
#             "name": "Morning Ritual v1",
#             "filename": "noteto-template-morning-ritual-v1",
#             "hasVariant": false,
#             "iconCode": "\ue9dc",
#             "categories": [
#                 "Life/organize"
#             ]
#         }
#     ]
# }

import json
import sys

def merge(base, additional, output):
    # Load the base templates file
    with open(base, 'r') as f:
        base_data = json.load(f)
    
    # Load the additional templates file
    with open(additional, 'r') as f:
        additional_data = json.load(f)
    
    # Create a dictionary of the base templates
    base_dict = {}
    for template in base_data['templates']:
        base_dict[template['name']] = template
    
    # Merge the additional templates into the base templates
    for template in additional_data['templates']:
        if template['name'] in base_dict:
            if DEBUG:
                print('Updating template:', template['name'])
                print('Current:', base_dict[template['name']])
            # Update the existing template
            base_dict[template['name']] = template
            if DEBUG:
                print('Updated:', base_dict[template['name']])
        else:
            # Add the new template
            base_dict['templates'].append(template)
    
    # Write the merged templates to a new file
    with open(output, 'w') as f:
        json.dump(base_dict, f, ensure_ascii=True, indent=4)

DEBUG = True
if __name__ == '__main__':
    if len(sys.argv) != 4:
        print('Usage: python merge.py base.json additional.json output.json')
        sys.exit(1)
    
    base = sys.argv[1]
    additional = sys.argv[2]
    output = sys.argv[3]
    
    merge(base, additional, output)
    print('Merged templates written to', output)