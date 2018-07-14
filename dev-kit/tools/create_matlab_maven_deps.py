# create_matlab_maven_deps.py
#
# This is a tool to create Maven dependency definitions for all the internal
# JARs in a Matlab distribution. (The "internal" JARs are those written by 
# MathWorks as part of Matlab and found in java/jar, as opposed to the third-
# party JARs found in java/jarext.)
#

import os
import sys

matlab_version = sys.argv[1]

matlab_app = "/Applications/MATLAB_"+matlab_version+".app"
matlab_jar_dir = matlab_app + "/java/jar"

skips = ["zh_CN", "ja_JP", "ko_KR"]

for root, subdirs, files in os.walk(matlab_jar_dir):
	rel_dir = root[len(matlab_jar_dir)+1:]

	if len(rel_dir) >= 5:
		first_five = rel_dir[:5]
		if first_five in skips:
			#print('-> Skipping locale dir');
			continue

	for filename in files:
		if not filename.endswith(".jar"):
			continue
		file_path = os.path.join(root, filename)
		#print('\t- file %s (full path: %s)' % (filename, file_path))
		qual = rel_dir.replace("/", ".")
		jar_base = filename[:-4]
		artifact = qual + "." + jar_base if qual else jar_base
		print('        <dependency>')
		print('            <groupId>com.mathworks.matlab</groupId>')
		print('            <artifactId>%s</artifactId>' % (artifact))
		print('            <version>%s</version>' % (matlab_version))
		print('            <scope>system</scope>')
		print('            <systemPath>%s</systemPath>' % (file_path))
		print('        </dependency>')
