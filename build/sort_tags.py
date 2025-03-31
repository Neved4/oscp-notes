#!/usr/bin/env python3

import os
import re
import yaml

def modify_tags(tags):
	priority = [
		"ProvingGrounds", "TryHackMe", "HackTheBox",
		"easy", "medium", "hard",
		"insane", "linux", "windows",
		"msof"
	]

	return sorted(set(tags),
		key=lambda t: (not any(t.startswith(p) for p in priority), t))

def process_md_file(file_path):
	try:
		with open(file_path, 'r', encoding='utf-8') as f:
			body = f.read()

		match = re.search(r'(?s)^---\n(.*?)\n---\s*(.*)', body)

		if match:
			meta_dict = yaml.safe_load(match.group(1))
			if 'tags' in meta_dict:
				src_tags = meta_dict['tags']
				out_tags = modify_tags(src_tags)
				if src_tags == out_tags:
					return

				meta_dict['tags'] = out_tags
				new_body = body.replace(match.group(1),
					yaml.dump(meta_dict, sort_keys=False).strip(), 1)

				with open(file_path, 'w', encoding='utf-8') as f:
					f.write(new_body)

				print(f"Updated tags in: {file_path}")

	except Exception as e:
		print(f"Error processing file {file_path}: {e}")

def parse_modify(directory):
	md_files = sorted(
		os.path.join(root, file)
		for root, _, files in os.walk(directory)
		for file in files if file.endswith(".md")
	)
	for file_path in md_files:
		process_md_file(file_path)

if __name__ == "__main__":
	parse_modify("./")
