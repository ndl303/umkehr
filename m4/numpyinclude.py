import site
import os

names = site.getusersitepackages()
found = False
for name in names:
   if (not found):
      fullname = name + os.sep +'numpy'+os.sep+'core'+os.sep+'include'
      found = os.path.isdir(fullname)
      if (found):
         print(fullname)
         
if (not found):
   names = site.getsitepackages()
   for name in names:
      if (not found):
         fullname = name + os.sep+'numpy'+os.sep+'core'+os.sep+'include'
         found = os.path.isdir(fullname)
         if (found):
            print(fullname)
            
if (not found):
   print('NOTFOUND')

