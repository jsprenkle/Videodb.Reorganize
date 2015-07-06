<!--
    This xslt script compares the content of two kodi exported video libraries to determine which movies were added to the video database.
    It produces a script to copy the new content to backup media.

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
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output omit-xml-declaration="yes" indent="yes" encoding="utf-8"/>
    <xsl:strip-space elements="*" />

    <xsl:param name="newer" select="'videodb.xml'"/>
    <xsl:param name="backup" select="'j:\backup'"/>

    <!--do not copy unmatched test-->
    <xsl:template match="text()|@*" />

    <!--The first document. Not a named parameter-->
    <xsl:variable name="olderVideoDb" select="/videodb[version/text()='1']" />

    <!--The 'newer' parameter on the command line-->
    <xsl:variable name="doc1" select="document( $newer )" />
    <xsl:variable name="newerVideoDb" select="$doc1/videodb[version/text()='1']" />

    <xsl:template match="/videodb">

        <mvXmlCmd xmlns="http://www.XmlCommandLine.org/mvXmlCmd/1.0">
            <Content>

                <!--find all movie nodes in the newer document with id's not present in the older document-->
                <xsl:variable name="MoviesAdded" select="$newerVideoDb/movie[ not( $olderVideoDb/movie/id/text() = id/text() ) ]" />
                
                <xsl:for-each select="$MoviesAdded">
                    <xsl:variable name="filenameandpath" select="filenameandpath/text()" />
                    <xsl:variable name="filename" select="substring( $filenameandpath, string-length(path/text()) + 1 )" />
                    <mv>
                        <xsl:attribute name="Source" >
                            <xsl:value-of select="$filenameandpath"/>
                        </xsl:attribute>
                        <xsl:attribute name="Destination" >
                            <xsl:value-of select="$backup"/>
                            <xsl:text>/Movies/</xsl:text>
                            <xsl:value-of select="year/text()"/>
                            <xsl:text>/</xsl:text>
                            <xsl:value-of select="$filename"/>
                        </xsl:attribute>
                    </mv>
                </xsl:for-each>

            </Content>
        </mvXmlCmd>
    </xsl:template>

</xsl:stylesheet>
