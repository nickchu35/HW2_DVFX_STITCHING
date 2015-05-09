import os
import shutil

name = 'prtn_'
count = 18

for filename in os.listdir("."):
	if filename[-4:-1] == '.jp':
		if count < 10:
			full_name = 'prtn_0' 
		else:
			full_name = name
		os.rename(filename, full_name + str(count) + '.jpg')
		#shutil.copy2(filename, full_name + str(count) + '.jpg')
		count = count - 1
