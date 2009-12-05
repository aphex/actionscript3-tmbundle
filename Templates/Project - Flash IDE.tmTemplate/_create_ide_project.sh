#!/bin/bash

#-------------------------------------------------------------------------
#
# New Flash IDE Rpoject
# 
# Simple Project template for compilation in the Flash IDE
#
#-------------------------------------------------------------------------

defaultProjectName="IDEProject.tmproj";
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
		mkdir -p "$projectPath/$projectName/bin";
		mkdir -p "$projectPath/$projectName/src";
		mkdir -p "$projectPath/$projectName/lib";
		mkdir -p "$projectPath/$projectName/fla";
		
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
		perl -pe 's/\$\{([^}]*)\}/$ENV{$1}/g' < "Project.as" > "$projectPath/$projectName/src/$classPath/$projectName.as";
		perl -pe 's/\$\{([^}]*)\}/$ENV{$1}/g' < "Project.fla" > "$projectPath/$projectName/fla/$projectName.fla";
		
		# Open the project in TextMate.
		open -a "TextMate.app" "$projectPath/$projectName/$projectName.tmproj";
		
	fi

fi