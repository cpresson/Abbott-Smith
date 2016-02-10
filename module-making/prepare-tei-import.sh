#/bin/bash

### Validates the TEI file against the schema. 
#xmllint --valid --noout ../abbott-smith.tei.xml --schema http://www.crosswire.org/OSIS/teiP5osis.2.5.0.xsd

### Copy current xml file into this directory.
cp ../abbott-smith.tei.xml abbott-smith.tei-current.xml

### Check if XML file is well-formed
xmllint -noout abbott-smith.tei-current.xml
 
### Removes frontmatter, page breaks, notes, headings, and comments
xsltproc  --output abbott-smith.tei-simple.xml abbott-smith-module.xsl abbott-smith.tei-current.xml

# Remove namespace junk
perl -pi -w -e 's/ xmlns=\"\" xmlns:TEI=\"http:\/\/www.crosswire.org\/2013\/TEIOSIS\/namespace\"//g;' abbott-smith.tei-simple.xml

# Change <entry> to <entryFree>
perl -pi -w -e 's/<entry/<entryFree/g;' abbott-smith.tei-simple.xml
perl -pi -w -e 's/entry>/entryFree>/g;' abbott-smith.tei-simple.xml

# Add 0 padding
perl -pi -w -e 's/(\"|\|)G(\d\d\d\d)(\"|\|)/$1G$2$3/g;' abbott-smith.tei-simple.xml
perl -pi -w -e 's/(\"|\|)G(\d\d\d)(\"|\|)/$1G0$2$3/g;' abbott-smith.tei-simple.xml
perl -pi -w -e 's/(\"|\|)G(\d\d)(\"|\|)/$1G00$2$3/g;' abbott-smith.tei-simple.xml
perl -pi -w -e 's/(\"|\|)G(\d)(\"|\|)/$1G000$2$3/g;' abbott-smith.tei-simple.xml

# Remove Greek from entry@n
perl -pi -w -e 's/<entryFree n=\"([^G]+)G/<entryFree n=\"G/g;' abbott-smith.tei-simple.xml

# Replace G with 0
perl -pi -w -e 's/\"G/\"0/g;' abbott-smith.tei-simple.xml
perl -pi -w -e 's/\|G/\|0/g;' abbott-smith.tei-simple.xml

# Remove unwanted XMLNS declarations
perl -pi -w -e 's/<foreign xmlns=\"http:\/\/www.crosswire.org\/2013\/TEIOSIS\/namespace\" /<foreign /g;' abbott-smith.tei-simple.xml
perl -pi -w -e 's/<hi xmlns=\"\" xmlns:TEI=\"http:\/\/www.crosswire.org\/2013\/TEIOSIS\/namespace\" /<hi /g;' abbott-smith.tei-simple.xml

# Cleanup
perl -pi -w -e 's/([\n]+)/\n/g;' abbott-smith.tei-simple.xml
perl -pi -w -e 's/<\/div>//g;' abbott-smith.tei-simple.xml
perl -pi -w -e 's/<div([^>]+)>//g;' abbott-smith.tei-simple.xml