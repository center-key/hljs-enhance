#!/bin/bash
################
# hljs-enhance #
################

# To make this file runnable:
#     $ chmod +x *.sh.command

banner="hljs-enhance"
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

creatLocalToCdnSubsitution() {
   cdnUri=https://centerkey.com/hljs-enhance
   localToCdn="s#=hljs-enhance[.]#=$cdnUri/hljs-enhance.#g"
   }

generateInstructions() {
   cd $projectHome
   echo -e "Paste the HTML below into the <head> section (after loading jQuery):\n" > $instructionsFile
   startLine=$(grep --line-number "\!\-\- \-" spec.html | head -1 | sed s/[^0-9]//g)
   endLine=$(($(grep --line-number "</head>" spec.html | sed s/[^0-9]//g) - 2))
   creatLocalToCdnSubsitution
   sed $localToCdn spec.html | head -$endLine | tail -n +$startLine  >> $instructionsFile
   cat $instructionsFile
   echo
   pwd
   ls -o
   echo
   }

publishWebFiles() {
   cd $projectHome
   publishWebRoot=$(grep ^DocumentRoot /private/etc/apache2/httpd.conf | awk -F'"' '{ print $2 }')
   publishSite=$publishWebRoot/centerkey.com
   publishFolder=$publishSite/hljs-enhance
   publish() {
      echo "Publishing:"
      echo $publishFolder
      mkdir -p $publishFolder
      sed $localToCdn spec.html > $publishFolder/index.html
      ls -o $publishFolder
      echo
      }
   test -w $publishSite && publish
   }

openBrowser() {
   cd $projectHome
   echo "Opening spec.html"
   sleep 2
   open spec.html
   echo
   }

displayIntro
generateInstructions
publishWebFiles
openBrowser
