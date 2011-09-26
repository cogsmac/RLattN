import os, sys

for i in range(1,4):
	os.system('qsub frandsearchRL.pbs -v Arg1=' + str(i))


#for k in range(1,16):
#	for i in range(1,100):
#		os.system('qsub frandsearchRL.pbs -v Arg1=' + str(i))
