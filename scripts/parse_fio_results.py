#!/usr/bin/env python3
"""
Parse FIO JSON output and return IOPS and bandwidth (MB/s).
Usage: parse_fio_results.py <json_file>
Output: iops,bw_mb
"""
import json
import sys
import os

def main():
    if len(sys.argv) != 2:
        print("0,0")
        sys.exit(1)

    filename = sys.argv[1]
    if not os.path.isfile(filename):
        print("0,0")
        sys.exit(0)

    try:
        with open(filename) as f:
            content = f.read()
            # Find the start of JSON (skip ansible header)
            start = content.find('{')
            if start == -1:
                print("0,0")
                return
            data = json.loads(content[start:])
        
        job = data.get("jobs", [{}])[0]
        
        # Check for errors (e.g., read-only filesystem)
        if job.get("error", 0) != 0:
            print("0,0")
            return
        
        if "read" in job and job["read"].get("iops", 0) > 0:
            iops = job["read"]["iops"]
            bw = job["read"]["bw"] / 1024
            print(f"{iops:.0f},{bw:.1f}")
        elif "write" in job and job["write"].get("iops", 0) > 0:
            iops = job["write"]["iops"]
            bw = job["write"]["bw"] / 1024
            print(f"{iops:.0f},{bw:.1f}")
        else:
            print("0,0")
    except Exception:
        print("0,0")

if __name__ == "__main__":
    main()