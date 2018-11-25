import sys
import os

basename = sys.prefix+os.sep +'include'
info = sys.version_info

names = []
names.append(basename)
names.append(basename + os.sep +'python'+str(info.major)+'.'+str(info.minor)+'m')
names.append(basename + os.sep +'python'+str(info.major)+'.'+str(info.minor))

found = False
for name in names:
   if (not found):
      fullname = name + os.sep + 'Python.h'
      found = os.path.exists(fullname)
      if (found):
         print(name)
if (not found):
   print('NOTFOUND')
