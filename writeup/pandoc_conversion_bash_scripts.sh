#I opened git Bash and ran the below commands in the writeup folder in vacant-lots-project.

# For converting markdown to pdf
pandoc -o draft.pdf -f markdown -t latex draft.md --bibliography "C:/Users/ajjit/Google Drive/Documents/vacant_lots_final/vacant-lots-project/writeup/citations_thesis.bib" --csl= "C:/Users/ajjit/Google Drive/Documents/vacant_lots_final/vacant-lots-project/writeup/apa.csl"

# For converting markdown to word
pandoc -o draft.docx -f markdown -t docx draft.md --bibliography "C:/Users/ajjit/Google Drive/Documents/vacant_lots_final/vacant-lots-project/writeup/citations_thesis.bib" --reference-doc="C:/Users/ajjit/Google Drive/Documents/Vacant_lots_final/vacant-lots-project/writeup/word-test-options.docx"
