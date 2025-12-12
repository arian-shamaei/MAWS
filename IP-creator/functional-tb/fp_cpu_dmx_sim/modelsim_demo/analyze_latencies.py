import re
from pathlib import Path
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

logs = {
    'Nominal': Path('vsim.log'),
    'Edge': Path('edge.log'),
}

data = {}

def parse_log(path, default_name=None):
    if not path.exists():
        return
    current_stage = None
    current_scenario = default_name
    stage_pattern = re.compile(r"Stage\s+(\d+)")
    latency_pattern = re.compile(r"Latency\s*:\s*(\d+)\s*cycles")
    scenario_pattern = re.compile(r"===\s*Scenario:\s*(.+?)\s*===")
    total_pattern = re.compile(r"Total cycles:\s*(\d+)")
    with path.open() as f:
        for raw in f:
            line = raw.strip().lstrip('#').strip()
            if not line:
                continue
            m = scenario_pattern.search(line)
            if m:
                current_scenario = m.group(1).strip().title()
                data.setdefault(current_scenario, {'total': None, 'stages': {}})
                continue
            if current_scenario is None:
                current_scenario = default_name or 'Scenario'
            data.setdefault(current_scenario, {'total': None, 'stages': {}})
            mt = total_pattern.search(line)
            if mt:
                data[current_scenario]['total'] = int(mt.group(1))
                continue
            ms = stage_pattern.search(line)
            if ms and 'Intel' not in line:
                current_stage = f"Stage {ms.group(1)}"
                continue
            ml = latency_pattern.search(line)
            if ml and current_stage:
                data[current_scenario]['stages'][current_stage] = int(ml.group(1))
                current_stage = None

parse_log(logs['Nominal'], 'Nominal')
parse_log(logs['Edge'])

# prune placeholder entries
for key in list(data.keys()):
    if key.lower() == 'scenario' and not data[key]['stages']:
        del data[key]

# Normalize scenario names
if 'Overflow' not in data:
    for key in list(data.keys()):
        if key.lower().startswith('overflow'):
            data['Overflow'] = data.pop(key)
if 'NaN Propagation' not in data:
    for key in list(data.keys()):
        if key.lower().startswith('nan'):
            data['NaN Propagation'] = data.pop(key)

scenarios = [sc for sc in ('Nominal','Overflow','NaN Propagation') if sc in data]
stages = ['Stage 1','Stage 2','Stage 3']
values = [[data[sc]['stages'].get(stage, 0) for stage in stages] for sc in scenarios]

if scenarios:
    fig, ax = plt.subplots(figsize=(8,4))
    x = range(len(scenarios))
    width = 0.2
    for idx, stage in enumerate(stages):
        offsets = [p + (idx-1)*width for p in x]
        ax.bar(offsets, [values[i][idx] for i in range(len(scenarios))], width, label=stage)
    ax.set_xticks(list(x))
    ax.set_xticklabels(scenarios)
    ax.set_ylabel('Latency (cycles)')
    ax.set_title('FP CPU stage latencies per scenario')
    ax.legend()
    fig.tight_layout()
    out_path = Path('cpu_stage_latency.png')
    fig.savefig(out_path, dpi=200)
    print(f"Wrote {out_path}")

for scenario, info in data.items():
    print(f"Scenario: {scenario}")
    if info['total'] is not None:
        print(f"  Total cycles: {info['total']}")
    for stage in stages:
        if stage in info['stages']:
            print(f"  {stage}: {info['stages'][stage]} cycles")
