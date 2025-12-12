import csv
from pathlib import Path
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

trace_files = sorted(Path('.').glob('cpu_trace_*.csv'))
rows_by_scenario = {}
for trace in trace_files:
    with trace.open() as f:
        reader = csv.DictReader(f)
        for row in reader:
            scenario = row['scenario'] if row.get('scenario') else trace.stem.replace('cpu_trace_','').title()
            rows_by_scenario.setdefault(scenario, []).append(row)

if not rows_by_scenario:
    print('No trace files found.')
    raise SystemExit(0)

node_order = ["FP32 Block", "FP64 Matrix", "CPU Output"]
y_pos = {node: idx for idx, node in enumerate(node_order)}
scenarios = list(rows_by_scenario.keys())
fig, axes = plt.subplots(len(scenarios), 1, figsize=(10, 3*len(scenarios)), sharex=True)
if len(scenarios) == 1:
    axes = [axes]

for ax, scenario in zip(axes, scenarios):
    ax.set_title(f"Data travel: {scenario}")
    ax.set_yticks(list(y_pos.values()))
    ax.set_yticklabels(node_order)
    ax.set_xlabel('Time (ns)')
    ax.grid(True, axis='x', linestyle='--', alpha=0.3)
    stages = rows_by_scenario[scenario]
    for row in stages:
        src = row['source']
        dst = row['destination']
        if src not in y_pos or dst not in y_pos:
            continue
        start = int(row['start_cycle']) * 10
        end = int(row['end_cycle']) * 10
        y0 = y_pos[src]
        y1 = y_pos[dst]
        ax.plot([start, end], [y0, y1], marker='o')
        label = f"{row['stage']}: {row['value_hex']} ({row['value_decimal']})"
        mid_x = (start + end) / 2 if start != end else start
        mid_y = (y0 + y1) / 2
        ax.text(mid_x, mid_y + 0.05, label, fontsize=8)

fig.tight_layout()
out_path = Path('cpu_data_flow.png')
fig.savefig(out_path, dpi=200)
print(f"Wrote {out_path}")
