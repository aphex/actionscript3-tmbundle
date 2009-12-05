#!/bin/bash

#-------------------------------------------------------------------------
#
# New Simple AS3 Project - Embeded
# 
# Removed extra folders in source directory. 
#Runs HTML file in browser with embeded SWF using SWFObject
#
#-------------------------------------------------------------------------

defaultProjectName="SimpleEmbededAS3Project.tmproj";
defaultClassPath="org.domain";

fullProjectPath=$(CocoaDialog filesave \
			--text "Please name your project and select a folder to save it into" \
			--title "Create New Project" \
			--with-extensions .tmproj \
			--with-file "$defaultProjectName");

if [ -n "$fullProjectPath" ]; then
	
	fullProjectPath=$(tail -n1 <<<"$fullProjectPath");
	projectName=`basename "$fullProjectPath" ".tmproj"`;
	projectPath=`dirname "$fullProjectPath"`;
	
	# Now ask what the class path should be, used to create default dirs.
	fullClassPath=$(CocoaDialog standard-inputbox \
				--title "Project Class Path" \
				--text "$defaultClassPath.$projectName" \
				--informative-text "Enter the project class path:");
	
	if [ -n "$fullClassPath" ]; then
		originalClassPath=$(tail -n1 <<<"$fullClassPath");
		classPath=`echo $originalClassPath | tr '.' '/'`;
		classPathDirectory="$projectPath/$projectName/src/$classPath/";
		
		# Create our project directory structure.
		#mkdir -p "$projectPath/$projectName/build";
		mkdir -p "$projectPath/$projectName/deploy/assets/common/css";
		mkdir -p "$projectPath/$projectName/deploy/assets/common/js";
		mkdir -p "$projectPath/$projectName/lib/src";
		mkdir -p "$projectPath/$projectName/lib/bin";
		mkdir -p "$projectPath/$projectName/src";
		mkdir -p "$projectPath/$projectName/config";
		
		#Create the ClassPath Directory 
		mkdir -p "$classPathDirectory";
		
		# Gather variables to be substituted.
		TM_NEW_FILE_BASENAME="$projectName";
		export TM_FILE_PACKAGE="$originalClassPath";
		export TM_FILE_PACKAGE_DIRECTORY="src/$classPath/";
		
		export TM_YEAR=`date "+%Y"`;
		export TM_DATE=`date "+%d.%m.%Y"`;
		
		# Customise file variables for the new project and rename
		# files to match the project name.
		perl -pe 's/\$\{([^}]*)\}/$ENV{$1}/g' < "Project.tmproj.xml" > "$projectPath/$projectName/$projectName.tmproj";
		perl -pe 's/\$\{([^}]*)\}/$ENV{$1}/g' < "Project-config.xml" > "$projectPath/$projectName/config/$projectName-config.xml";
		perl -pe 's/\$\{([^}]*)\}/$ENV{$1}/g' < "Project.as" > "$projectPath/$projectName/src/$classPath/$projectName.as";
		perl -pe 's/\$\{([^}]*)\}/$ENV{$1}/g' < "index.html" > "$projectPath/$projectName/deploy/index.html";
		
		# For the debug html version of the modify the file name.
		TM_NEW_FILE_BASENAME="$projectName-debug";
		
		perl -pe 's/\$\{([^}]*)\}/$ENV{$1}/g' < "index.html" > "$projectPath/$projectName/deploy/index-debug.html";

		# Copy static files.		
		cp "main.css" "$projectPath/$projectName/deploy/assets/common/css/main.css";
		cp "swfaddress.js" "$projectPath/$projectName/deploy/assets/common/js/swfaddress.js";
		cp "swfobject.js" "$projectPath/$projectName/deploy/assets/common/js/swfobject.js";
		
		# Open the project in TextMate.
		open -a "TextMate.app" "$projectPath/$projectName/$projectName.tmproj";
		
	fi

fi