" RDF Notation 3 Syntax 
augroup filetypedetect 
  au BufNewFile,BufRead *.n3  setfiletype n3 
  au BufNewFile,BufRead *.sparql  setfiletype n3 
  au BufNewFile,BufRead *.ttl  setfiletype n3 
  au BufNewFile,BufRead *.rdf  setfiletype xml 
augroup END 
