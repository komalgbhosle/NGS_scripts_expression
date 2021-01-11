import os
import csv

try:
    os.mkdir('tpm_matrix')
except FileExistsError:
    pass

mapping = {}

with open('study_sample_mapping.csv') as f:
    reader = csv.reader(f, delimiter='\t')
    next(reader, None)
    for row in reader:
        mapping.setdefault(row[0], []).append(row[1])

for k,v in mapping.items():
    print(f"Processing study {k}...")
    data = {}
    for sample in v:
        print(f"\tProcessing sample {sample}...", end='')
        try:
            with open(os.path.join(sample, 'quant.sf')) as f:
                reader = csv.reader(f, delimiter='\t')
                next(reader, None)
                for row in reader:
                    data.setdefault(row[0], {})[sample] = row[3]
        except FileNotFoundError:
            print("file not found")
        else:
            print("done")
    if not data:
        continue
    with open(os.path.join('tpm_matrix', k), 'w') as f_out:
        writer = csv.writer(f_out, delimiter='\t')
        writer.writerow(['Gene', *v])
        for g,d in data.items():
            writer.writerow([g, *[d.get(sample, '') for sample in v]])

