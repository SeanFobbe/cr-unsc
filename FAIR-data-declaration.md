# FAIR Data Conformity Declaration

The FAIR Principles lay out a leading global set of guiding standards for the management of scientific data. Four principles make up the FAIR standard: [F]indable, [A]ccessible [I]nteroperable and [R]eusable. It is the intention of the author(s) to be fully compliant with the FAIR standard. This conformity declaration is intended to provide further information on what measures have been taken to achieve this compliance.

For the original publication proposing the FAIR standard, see:

Wilkinson, M. D. et al. The FAIR Guiding Principles for scientific data management and stewardship. Sci. Data 3:160018 doi: 10.1038/sdata.2016.18 (2016).


## Findable

### F1. (Meta)data are assigned a globally unique and persistent identifier

- The dataset and source code are published with Zenodo, a major scientific repository operated by CERN.
- Zenodo issues a DOI for the dataset as a whole and a DOI for each individual version of the dataset and source code.

### F2. Data are described with rich metadata (defined by R1 below)

- Zenodo's metadata is compliant with DataCite's Metadata Schema minimum and recommended terms
- The author(s) have provided significant metadata to augment the Zenodo record, such as a lengthy description, keywords, publication details, license, related works and contact details for the maintainer(s)

### F3. Metadata clearly and explicitly include the identifier of the data they describe

- With Zenodo the DOI is a top-level and a mandatory field in the metadata of each record

### F4. (Meta)data are registered or indexed in a searchable resource

- Metadata is indexed in and searchable via Zenodo
- Metadata is indexed in and searchable via DataCite



## Accessible

### A1. (Meta)data are retrievable by their identifier using a standardised communications protocol

- Zenodo provides a public OAI-PMH interface to retrieve metadata of individual records and whole collections
- Zenodo provides a public REST API to retrieve metadata of individual records

### A1.1 The protocol is open, free, and universally implementable

- OAI-PMH and REST are open, free and universally implementable protocols 

### A1.2 The protocol allows for an authentication and authorisation procedure, where necessary

- Zenodo provides all metadata publicly and without authentication under a public domain license

### A2. Metadata are accessible, even when the data are no longer available

- Zenodo guarantees that metadata remain available for the lifetime of the parent organization CERN, which has a defined experimental program for the next 20 years
- Metadata are stored in different servers than the data at Zenodo
- Zenodo commits to providing a "data tombstone" of the record that contains all metadata even if data becomes unavailable for legal or other reasons




## Interoperable

### I1. (Meta)data use a formal, accessible, shared, and broadly applicable language for knowledge representation.

### I2. (Meta)data use vocabularies that follow FAIR principles

### I3. (Meta)data include qualified references to other (meta)data




## Reusable

### R1. (Meta)data are richly described with a plurality of accurate and relevant attributes

#### R1.1. (Meta)data are released with a clear and accessible data usage license

#### R1.2. (Meta)data are associated with detailed provenance

#### R1.3. (Meta)data meet domain-relevant community standards
