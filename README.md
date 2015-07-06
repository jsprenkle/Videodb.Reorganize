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

  msxsl 2015-06-01\videodb.xml -o backup.xml Videodb.Reorganize.xslt newer="2015-06-08\videodb.xml" backup="j:\backup"

msxsl parameters to use this script:
  * The file name of the older kodi videodb document ( example: 2015-06-01\videodb.xml )
  * Output file name for the copy script ( example: -o backup.xml )
  * The file name of the newer kodi videodb document ( example: newer="2015-06-08\videodb.xml" )
  * A path where backups go ( backup="j:\backup" )

Notes:
  * This example uses the microsoft xsl interpreter named 'msxsl'. There are many other interpreters that this script
    will probably work with. If you use another interpreter the command line will need to be changed.
  * The first document should be produced chronologically before the newer second document.
  * The copy script is an xml document used by the cpXmlCmd application.
  * uses Version 1 of the videodb.xml file.

Linux example Using xalan:
  xalan 2015-06-01/videodb.xml -p newer "2015-06-08/videodb.xml" -p backup "/mnt/backup" Videodb.Reorganize.xslt -o backup.xml

xalan parameters to use this script:
  * The file name of the older kodi videodb document ( example: 2015-06-01/videodb.xml )
  * The file name of the newer kodi videodb document ( example: -p newer="2015-06-08/videodb.xml" )
  * A path where backups go ( -p backup="/mnt/backup" )
  * Output file name for the copy script ( example: -o backup.xml )

Notes:
  * This example uses the xalan xsl interpreter'
  * The first document should be produced chronologically before the newer second document.
  * The copy script is an xml document used by the cpXmlCmd application.
  * uses Version 1 of the videodb.xml file.

written by Jay Sprenkle
