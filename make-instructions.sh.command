#!/bin/sh
################
# hljs-enhance #
################

# To make this file runnable:
#     $ chmod +x *.sh.command

htmlFile=examples.html
instructionsFile=instructions.txt
projectHome=$(cd $(dirname $0); pwd)

generateInstructions() {
   cd $projectHome
   echo "Paste HTML below into the <head> section (after loading jQuery):\n" > $instructionsFile
   startLine=$(grep -n "\!\-\- \-" $htmlFile | head -1 | sed s/:.*//)
   endLine=$(grep -n "</head>"  $htmlFile | sed s/:.*//)
   head -$endLine < $htmlFile | sed '$d' | tail -n +$startLine >> $instructionsFile
   cat $instructionsFile
   echo
   pwd
   ls -l
   echo
   }

publishWebFiles() {
   cd $projectHome
   publishWebRoot=$(grep ^DocumentRoot /private/etc/apache2/httpd.conf | awk -F\" '{ print $2 }')
   publishSite=$publishWebRoot/centerkey.com
   publishFolder=$publishSite/files/hljs-enhance
   publish() {
      echo "Publishing:"
      mkdir -p $publishFolder
      cp -v hljs-enhance.* examples.html $publishFolder
      echo
      }
   test -w $publishSite && publish
   }

openBrowser() {
   cd $projectHome
   echo "Opening examples.html"
   sleep 2
   open examples.html
   echo
   }

generateInstructions
publishWebFiles
openBrowser
