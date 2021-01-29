#!/bin/bash
usage () 
{
  echo "Usage: ${0##*/} {NDJSON} <ttl|nt>"
  exit 1
}

if [ -z $APACHE_JENA_HOME ]
then
  # auto detect jena location
  rdfxml=$(which rdfxml)
  if [ -z $rdfxml ]
  then
    echo "Apache Jena CLI tool 'rdfxml' not found" 1>&2
    echo "Please set \$APACHE_JENA_HOME or put the Apache Jena bin dir in your PATH" 1>&2
    exit 1
  fi
else 
   rdfxml=$APACHE_JENA_HOME/bin/rdfxml
   if [ ! -f $rdfxml ]
   then
     echo "Apache Jena CLI tool 'rdfxml' not found at $APACHE_JENA_HOME/bin " 1>&2
     echo "Please change \$APACHE_JENA_HOME or put the Apache Jena bin dir in your PATH" 1>&2
     exit 1
   fi
fi

[ $# -eq 1 -o $# -eq 2 ] || usage

ndjson=$1
test -f $ndjson || {
  echo "NDJSON file '$ndjson' not found" 1>&2
  exit 1
}

test $(file -b --mime-type "$ndjson") == 'application/json' || {
  echo "NDJSON file '$ndjson' is not of mime-type 'application/json'" 1>&2
  exit 1
}

outputFormat=ttl
test -z $2 || outputFormat=$(echo "$2" | tr [A-Z] [a-z] )

test $outputFormat = "ttl" -o $outputFormat = "nt" || {
  echo "Valid output formats as 'ttl' (Turtle) and 'nt' (N-Triples)" 1>&2
  exit 1
}

head -n 1 $ndjson | rdfxml --syntax=json-ld --out=$outputFormat | grep @prefix
echo
cat $ndjson | while read line
do
  echo "$line" | rdfxml --syntax=json-ld --out=$outputFormat | grep -v @prefix
  test $? -eq 0 || {
    echo $line 1>&2
  }
done
