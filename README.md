# ndjson2ttl
Converts JSON-LD stored in Newline Delimited JSON to a Turtle file (or N-Triples)

Converts the download from [Iconclass](http://iconclass.org), which is a
[Newline Delimited JSON](http://ndjson.org/) to Turtle or N-Triples RDF serialization 
by using [Apache Jena's](https://jena.apache.org/) `rdfxml`

### prerequisites
- Java runtime environment 
- Apache Jena bin tools

### install
Better instalations are possible, but to use this as a single-use tool, just clone this
repository, donwload the Iconclass NDJSON LoD file, download Apache Jena and you should be fine.

### usage
Usage: `nl2json2rdf.sh inputfile.ndjson [ttl|nt]`

This tool uses simple strings to create a single file
by processing line by line and print valid TTL/NT to STDOUT. Errors in the source NDJSON file
are printed to STDERR. After the script has finished, you can always use Apache Jena's rdfxml
to convert to other than TTL or NT, e.g. `xmlrdf iconclass.nt --out=jsonld`
Please not this: only the @prefix declared in the first Graph are copied to STDOUT!

Example: `nljson2rdf.sh iconclass.ndjson nt 1>iconclass.nt 2>iconclass.errors.ndjson`

### single use run example

`git clone https://github.com/mightymax/ndjson2ttl.git`
`wget http://iconclass.org/data/iconclass_20200710_skos_jsonld.ndjson.gz`
`gunzip iconclass\_20200710\_skos_jsonld.ndjson.gz`
`wget https://ftp.nluug.nl/internet/apache/jena/binaries/apache-jena-3.17.0.tar.gz`
`tar zxvf apache-jena-3.17.0.tar.gz`
`APACHE\_JENA\_HOME=./apache-jena-3.17.0 ./ndjson2ttl/ndjson2ttl.sh iconclass.ndjson nt 1>iconclass.nt 2>iconclass.errors.ndjson`
`
