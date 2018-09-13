#!/bin/bash
################
# hljs-enhance #
################

# To make this file runnable:
#     $ chmod +x *.sh.command

banner="hljs-enhance"
htmlFile=examples.html
instructionsFile=instructions.txt
projectHome=$(cd $(dirname $0); pwd)

displayIntro() {
   cd $projectHome
   echo
   echo $banner
   echo $(echo $banner | sed s/./=/g)
   pwd
   echo
   }

generateInstructions() {
   cd $projectHome
   echo -e "Paste the HTML below into the <head> section (after loading jQuery):\n" > $instructionsFile
   startLine=$(grep -n "\!\-\- \-" $htmlFile | head -1 | sed s/:.*//)
   endLine=$(grep -n "</head>"  $htmlFile | sed s/:.*//)
   head -$endLine < $htmlFile | sed '$d' | tail -n +$startLine >> $instructionsFile
   cat $instructionsFile
   echo
   pwd
   ls -o
   echo
   }

publishWebFiles() {
   cd $projectHome
   publishWebRoot=$(grep ^DocumentRoot /private/etc/apache2/httpd.conf | awk -F\" '{ print $2 }')
   publishSite=$publishWebRoot/centerkey.com
   publishFolder=$publishSite/hljs-enhance
   publish() {
      echo "Publishing:"
      mkdir -p $publishFolder
      cp -v hljs-enhance.* examples.html $publishFolder
      msg="\n/* Published: $(date) */"
      echo -e $msg >> $publishFolder/hljs-enhance.css
      echo -e $msg >> $publishFolder/hljs-enhance.js
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

displayIntro
generateInstructions
publishWebFiles
openBrowser
