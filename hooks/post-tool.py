#!/usr/bin/env python3
import sys
import json
import subprocess

def log(msg):
    print(f"[cmux-hook] {msg}", file=sys.stderr)

def main():
    try:
        # Read the stdin JSON
        data = json.load(sys.stdin)
        
        # Check if we have toolCall info
        tool_call = data.get("toolCall") or data.get("step", {}).get("toolCall")
        if not tool_call:
            # Output empty JSON as required
            print(json.dumps({}))
            return

        tool_name = tool_call.get("name", "")
        args = tool_call.get("args", {})
        
        # Common file path keys in write/edit tools
        file_path = None
        for key in ["TargetFile", "targetFile", "path", "file", "filepath", "TargetPath", "targetPath", "Target"]:
            if key in args:
                file_path = args[key]
                break

        if file_path and isinstance(file_path, str) and file_path.lower().endswith(".md"):
            log(f"Detected markdown file: {file_path}")
            # Run cmux markdown command in a non-blocking detached process
            cmd = ["cmux", "markdown", file_path, "--focus", "false"]
            subprocess.Popen(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            
    except Exception as e:
        log(f"Error: {e}")

    # Always output empty JSON on stdout to satisfy the PostToolUse contract
    print(json.dumps({}))

if __name__ == "__main__":
    main()
