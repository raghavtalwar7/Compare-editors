import os
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Define the root directory containing the editor-named subfolders
results_folder = "C:\Users\ragha\Compare-editors\results"  # Change this to your actual path

# Initialize an empty DataFrame
df = pd.DataFrame(columns=["Time", "PACKAGE_ENERGY (J)", "Editor"])

# Iterate through each editor's folder
for editor in ["Vim", "Neovim", "Notepad++"]:
    editor_path = os.path.join(results_folder, editor)

    # Check if the directory exists
    if not os.path.exists(editor_path):
        continue

    # Process each CSV file in the folder
    for filename in os.listdir(editor_path):
        file_path = os.path.join(editor_path, filename)

        if filename.endswith(".csv"):
            try:
                # Read the CSV file
                data = pd.read_csv(file_path)

                # Extract relevant columns
                extracted_data = data[["Time", "PACKAGE_ENERGY (J)"]].copy()
                extracted_data["Editor"] = editor  # Assign editor name

                # Append to the main DataFrame
                df = pd.concat([df, extracted_data], ignore_index=True)

            except Exception as e:
                print(f"Error processing file {filename}: {e}")

# Convert Time column to numeric if needed
df["Time"] = pd.to_numeric(df["Time"], errors="coerce")
df["PACKAGE_ENERGY (J)"] = pd.to_numeric(df["PACKAGE_ENERGY (J)"], errors="coerce")

# Drop any rows with missing values
df = df.dropna()

# Box Plot
plt.figure(figsize=(10, 6))
sns.boxplot(x="Editor", y="PACKAGE_ENERGY (J)", data=df)
plt.title("Box Plot of PACKAGE_ENERGY (J) by Editor")
plt.show()

# Histogram Plot
plt.figure(figsize=(10, 6))
sns.histplot(data=df, x="PACKAGE_ENERGY (J)", hue="Editor", kde=True, bins=30)
plt.title("Distribution of PACKAGE_ENERGY (J)")
plt.xlabel("Energy (J)")
plt.ylabel("Frequency")
plt.show()

# Violin Plot
plt.figure(figsize=(10, 6))
sns.violinplot(x="Editor", y="PACKAGE_ENERGY (J)", data=df)
plt.title("Violin Plot of PACKAGE_ENERGY (J) by Editor")
plt.show()