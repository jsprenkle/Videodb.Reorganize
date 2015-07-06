# Videodb.Reorganize
xslt script to maintain backups of kodi entertainment center media files

This xslt script compares the content of two kodi exported video libraries to determine which movies were added to the video database.
It produces an xml document that describes how to copy the new content to backup media.
That document is used by the cpXmlCmd application to actually perform the file copy

This script will organize movies in the backup by year.
Putting all movies in one directory will eventually become an issue. There are limits to number of files
stored in a directory and performance issues arise before the limit is reached.

Organizing by title isn't great either. Extracting the title isn't trivial in xsl.
Titles are very unevenly distributed in the alphabet so this just delays the same issues as a single directory.

Organizing by year seems the best trade off. Files will not accumulate infinitely in a single directory
but it's more difficult for a human to navigate to a movie of a given title using a file explorer.
Viewing the movie list in kodi isn't affected by this organization.

Microsoft windows command line example:

  msxsl 2015-06-01\videodb.xml -o backup.xml Videodb.Additions.xslt newer="2015-06-08\videodb.xml" backup="j:\backup"

  msxsl parameters to use this script:
  1. The file name of the older kodi videodb document ( example: 2015-06-01\videodb.xml )
  2. Output file name for the copy script ( example: -o backup.xml )
  3. The file name of the newer kodi videodb document ( example: newer="2015-06-08\videodb.xml" )
  4. A path where backups go ( backup="j:\backup" )

  Notes:
  * This example uses the microsoft xsl interpreter named 'msxsl'. There are many other interpreters that this script
    will probably work with. If you use another interpreter the command line will need to be changed.
  * The first document should be produced chronologically before the newer second document.
  * The copy script is an xml document used by the cpXmlCmd application.
  * Individual movies will be placed in a separate directory for each movie in the backup.
  * uses Version 1 of the videodb.xml file.

Linux example Using xalan:
  xalan 2015-06-01/videodb..xml -p newer "2015-06-08/videodb.xml" -p backup "/mnt/backup" Videodb.Additions.xslt -o backup.xml

written by Jay Sprenkle
