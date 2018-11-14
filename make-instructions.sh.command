#!/bin/bash
################
# hljs-enhance #
################

# To make this file runnable:
#     $ chmod +x *.sh.command

banner="hljs-enhance"
instructionsFile=instructions.txt
projectHome=$(cd $(dirname $0); pwd)

setupTools() {
   # Check for Node.js installation and download project dependencies
   cd $projectHome
   echo
   echo $banner
   echo $(echo $banner | sed s/./=/g)
   pwd
   echo
   echo "Node.js:"
   which node || { echo "Need to install Node.js: https://nodejs.org"; exit; }
   node --version
   npm install
   npm update
   npm outdated
   echo
   }

releaseInstructions() {
   cd $projectHome
   repository=$(grep repository package.json | awk -F'"' '{print $4}' | sed s/github://)
   package=https://raw.githubusercontent.com/$repository/master/package.json
   version=v$(grep '"version"' package.json | awk -F'"' '{print $4}')
   pushed=v$(curl --silent $package | grep '"version":' | awk -F'"' '{print $4}')
   released=$(git tag | tail -1)
   echo "Local changes:"
   git status --short
   echo
   echo "Recent releases:"
   git tag | tail -5
   echo
   echo "Release progress:"
   echo "   $version (local) --> $pushed (pushed) --> $released (released)"
   echo
   echo "Next release action:"
   nextActionUpdate() {
      echo "   === Increment version ==="
      echo "   Edit pacakge.json to bump $version to next version number"
      echo "   $projectHome/package.json"
      }
   nextActionCommit() {
      echo "   === Commit and push ==="
      echo "   Check in changed source files for $version with the message:"
      echo "   Next release"
      }
   nextActionTag() {
      echo "   === Release checkin ==="
      echo "   Check in remaining changed files with the message:"
      echo "   Release $version"
      echo "   === Tag and publish ==="
      echo "   cd $projectHome"
      echo "   git tag --annotate --message 'Release' $version"
      echo "   git remote --verbose"
      echo "   git push origin --tags"
      echo "   npm publish"
      }
   checkStatus() {
      test "$version" ">" "$pushed" && nextActionCommit || nextActionUpdate
      }
   test "$pushed" ">" "$released" && nextActionTag || checkStatus
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
   sed $localToCdn spec.html | head -$endLine | tail -n +$startLine  >> $instructionsFile
   cat $instructionsFile
   echo
   pwd
   ls -o
   echo
   }

runTasks() {
   cd $projectHome
   echo "Tasks:"
   npm test
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

setupTools
releaseInstructions
creatLocalToCdnSubsitution
generateInstructions
runTasks
publishWebFiles
openBrowser
