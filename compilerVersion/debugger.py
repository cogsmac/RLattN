#This file will allow you to more easily make changes to compiled versions of a script on orcinus.
#You will definitely need to modify this file to suit individual purposes.

#precondition: add the same public key you added to orcinus to authorized_keys to snowpatch authorized keys


import os, sys

os.system('tar -cvvf src.tar src')

os.system('ssh jordanb@snowpatch.westgrid.ca \"rm -rf src.tar src deploy.tar deploy/*\"')

os.system('scp src.tar jordanb@snowpatch.westgrid.ca:./')

os.system('ssh jordanb@snowpatch.westgrid.ca \"tar -xvf src.tar; cd src;rm ._* .DS*; rm -rf .svn; cd redundantSupport; rm -rf .svn; cd ..; matlab -nosplash -nodesktop -r \\\"mcc -R -nodisplay -R -nojvm -R -singleCompThread -l -a ./ -m -v -w  enable -d ../deploy frandsearchRLserialCompile.m;quit\\\"; cd ..;tar -cvvf deploy.tar deploy;exit\"')

os.system('ssh jordanb@orcinus.westgrid.ca \"rm -rf deploy deploy.tar\"')

os.system('ssh jordanb@snowpatch.westgrid.ca \"scp deploy.tar jordanb@orcinus.westgrid.ca:./\"')

os.system('ssh jordanb@orcinus.westgrid.ca \"tar -xvf deploy.tar; cd deploy; ./run_frandsearchRLserialCompile.sh /global/software/matlab/mcr/v711 5\"')


#Alternatives to this file may require using stdin. This is terrible terrible news. This is an example of the kind of calls that may be required:
#import subprocess
#p = Popen(['sftp', 'jordanb@snowpatch.westgrid.ca'], stdout=PIPE, stdin=PIPE, stderr=STDOUT)
#ls_stdout = p.communicate(input='ls')[0]
#print(ls_stdout)
#or
#p.stdin.write("ls")



