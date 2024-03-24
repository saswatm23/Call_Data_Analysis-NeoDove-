import pandas as pd
import json
import ast

df = pd.read_csv(r"Organisation.csv")

# Convert string representations of dictionaries to actual dictionaries
df['properties'] = df['properties'].apply(ast.literal_eval)

# Extracting email, company, and location from the 'properties' column
emails = df['properties'].apply(lambda x: x['email']).tolist()
companies = df['properties'].apply(lambda x: x['company']).tolist()
locations = df['properties'].apply(lambda x: x['location']).tolist()

Properties = pd.DataFrame({"emails":emails,"companies":companies,"locations":locations})

Properties.to_csv(r"C:\Users\saswa\OneDrive\Desktop\DBDA\Projects\NeoDove Assignment\Properties.csv")




    