# Introduction

Old UNSC resolutions are not born-digital. They have been OCR'd with Tesseract, but several quality problms remain:

- If the quality of the scan is poor, so is the resulting OCR text
- Many files contain the same document in multiple languages (e.g. English/French)
- Many files contain multiple resolutions and decision, not just the one indicated in the metadata.

To acquire gold standard resolution texts, the OCR texts must be revised by hand. These instructions lay out the process for this work.

# Preparation

To make the work quick and efficient, the first 900 resolutions have been provided to you as original PDF files and as OCR text files.


# Step 1: Remove documents that do not match metadata

Please remove the text of all documents that do not match the metadata of the file.

Example: The PDF and TXT files with the filename referring to resolution 32 contains two documents: resolution 31 and resolution 32. You should remove all text from the TXT file that refers to resolution 31, so that only the text for resolution 32 remains.

# Step 2: Remove French text

Please remove all French text. The result should be a monolingual English resolution text.

During this time we will only produce gold standard English resolutions. If funds and time are available, we will also work on French texts.

Example: The TXT file for resolution 32 contains the French version of the resolution. Remove this text.



# Step 3: Check TXT file against original PDF scan

Please check the quality of the OCR text against the original PDF scan supplied to you. It should often be a perfect match, but if it is not, please make sure the TXT file has the exact text as given in the scan.

Example: the text file  of resolution 32 gives [S/525, IY] as the document number of the draft, but this is an error and [S/525, II] is correct. Please make sure that all errors are corrected.


Notes: 

- This is probably the most labor-intensive step.
- Precision is important, otherwise citation analysis and keyword searches will fail!
- Footnote numbering in the text should be separated by a single space from the word it refers to, so the original word is correctly recognized and the footnote number can be removed easily by later data cleaning


# Step 4: Store revised file in Drive

Please store the revised TXT file in Drive, in the the folder "revision-complete". Make sure it is uploaded.

Leave the file name intact, so that I know which resolution it refers to.









