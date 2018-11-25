import sys
import os
import os.path

basename = sys.prefix+ os.sep+'lib'+os.sep+'lib'
info = sys.version_info

names = []
names.append('python3.so')
names.append('python3.dll.a')
names.append('python'+str(info.major)+'.'+str(info.minor)+'m.so')
names.append('python'+str(info.major)+'.'+str(info.minor)+'m.dll.a')
names.append('python'+str(info.major)+'.'+str(info.minor)+'.so')
names.append('python'+str(info.major)+'.'+str(info.minor)+'.dll.a')

found = False
for name in names:
   if (not found):
      fullname = basename + name
      found = os.path.exists(fullname)
      if (found):
        name,ext = os.path.splitext(name)
        print(name)
if (not found):
   print('NOTFOUND')

