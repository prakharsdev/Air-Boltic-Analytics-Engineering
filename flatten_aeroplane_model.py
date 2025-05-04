import json
import csv

# 1. Load the JSON file
with open('seeds/aeroplane_model.json', 'r') as f:
    data = json.load(f)

# 2. Prepare the flattened data
rows = []
for manufacturer, models in data.items():
    for model, specs in models.items():
        row = {
            'manufacturer': manufacturer,
            'model': model,
            'max_seats': specs['max_seats'],
            'max_weight': specs['max_weight'],
            'max_distance': specs['max_distance'],
            'engine_type': specs['engine_type']
        }
        rows.append(row)

# 3. Define CSV column headers
fieldnames = ['manufacturer', 'model', 'max_seats', 'max_weight', 'max_distance', 'engine_type']

# 4. Write to CSV
with open('seeds/aeroplane_models.csv', 'w', newline='', encoding='utf-8') as f:
    writer = csv.DictWriter(f, fieldnames=fieldnames)
    writer.writeheader()
    writer.writerows(rows)

print("aeroplane_models.csv created successfully!")
