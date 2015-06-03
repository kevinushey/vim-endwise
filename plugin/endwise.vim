" Location:     plugin/endwise.vim
" Author:       Tim Pope <http://tpo.pe/>
" Version:      1.2
" License:      Same as Vim itself.  See :help license
" GetLatestVimScripts: 2386 1 :AutoInstall: endwise.vim

if exists("g:loaded_endwise") || &cp
  finish
endif
let g:loaded_endwise = 1

augroup endwise " {{{1
  autocmd!
  autocmd FileType lua
        \ let b:endwise_addition = 'end' |
        \ let b:endwise_words = 'function,do,then' |
        \ let b:endwise_pattern = '^\s*\zs\%(\%(local\s\+\)\=function\)\>\%(.*\<end\>\)\@!\|\<\%(then\|do\)\ze\s*$' |
        \ let b:endwise_syngroups = 'luaFunction,luaStatement,luaCond'
  autocmd FileType elixir
        \ let b:endwise_addition = 'end' |
        \ let b:endwise_words = 'do,fn' |
        \ let b:endwise_pattern = '.*[^.:@$]\zs\<\%(do\(:\)\@!\|fn\)\>\ze\%(.*[^.:@$]\<end\>\)\@!' |
        \ let b:endwise_syngroups = 'elixirKeyword'
  autocmd FileType ruby
        \ let b:endwise_addition = 'end' |
        \ let b:endwise_words = 'module,class,def,if,unless,case,while,until,begin,do' |
        \ let b:endwise_pattern = '^\(.*=\)\?\s*\%(private\s\+\|protected\s\+\|public\s\+\|module_function\s\+\)*\zs\%(module\|class\|def\|if\|unless\|case\|while\|until\|for\|\|begin\)\>\%(.*[^.:@$]\<end\>\)\@!\|\<do\ze\%(\s*|.*|\)\=\s*$' |
        \ let b:endwise_syngroups = 'rubyModule,rubyClass,rubyDefine,rubyControl,rubyConditional,rubyRepeat'
  autocmd FileType crystal
        \ let b:endwise_addition = 'end' |
        \ let b:endwise_words = 'module,class,lib,macro,struct,union,enum,def,if,unless,ifdef,case,while,until,for,begin,do' |
        \ let b:endwise_pattern = '^\(.*=\)\?\s*\%(private\s\+\|protected\s\+\|public\s\+\|abstract\s\+\)*\zs\%(module\|class\|lib\|macro\|struct\|union\|enum\|def\|if\|unless\|ifdef\|case\|while\|until\|for\|begin\)\>\%(.*[^.:@$]\<end\>\)\@!\|\<do\ze\%(\s*|.*|\)\=\s*$' |
        \ let b:endwise_syngroups = 'crystalModule,crystalClass,crystalLib,crystalMacro,crystalStruct,crystalDefine,crystalConditional,crystalRepeat,crystalControl'
  autocmd FileType sh,zsh
        \ let b:endwise_addition = '\=submatch(0)=="then" ? "fi" : submatch(0)=="case" ? "esac" : "done"' |
        \ let b:endwise_words = 'then,case,do' |
        \ let b:endwise_pattern = '\%(^\s*\zscase\>\ze\|\zs\<\%(do\|then\)\ze\s*$\)' |
        \ let b:endwise_syngroups = 'shConditional,shLoop,shIf,shFor,shRepeat,shCaseEsac,zshConditional,zshRepeat,zshDelimiter'
  autocmd FileType vb,vbnet,aspvbs
        \ let b:endwise_addition = 'End &' |
        \ let b:endwise_words = 'Function,Sub,Class,Module,Enum,Namespace' |
        \ let b:endwise_pattern = '\%(\<End\>.*\)\@<!\<&\>' |
        \ let b:endwise_syngroups = 'vbStatement,vbnetStorage,vbnetProcedure,vbnet.*Words,AspVBSStatement'
  autocmd FileType vim
        \ let b:endwise_addition = 'end&' |
        \ let b:endwise_words = 'fu,fun,func,function,wh,while,if,for,try' |
        \ let b:endwise_syngroups = 'vimFuncKey,vimNotFunc,vimCommand'
  autocmd FileType c,cpp,xdefaults
        \ let b:endwise_addition = '#endif' |
        \ let b:endwise_words = 'if,ifdef,ifndef' |
        \ let b:endwise_pattern = '^\s*#\%(if\|ifdef\|ifndef\)\>' |
        \ let b:endwise_syngroups = 'cPreCondit,cPreConditMatch,cCppInWrapper,xdefaultsPreProc'
  autocmd FileType objc
        \ let b:endwise_addition = '@end' |
        \ let b:endwise_words = 'interface,implementation' |
        \ let b:endwise_pattern = '^\s*@\%(interface\|implementation\)\>' |
        \ let b:endwise_syngroups = 'objcObjDef'
  autocmd FileType matlab
        \ let b:endwise_addition = 'end' |
        \ let b:endwise_words = 'function,if,for' |
        \ let b:endwise_syngroups = 'matlabStatement,matlabFunction,matlabConditional,matlabRepeat'
  autocmd FileType htmldjango
        \ let b:endwise_addition = '{% end& %}' |
        \ let b:endwise_words = 'autoescape,block\(\s\+\S*\)\?,blocktrans,cache,comment,filter,for,if,ifchanged,ifequal,ifnotequal,language,spaceless,verbatim,with' |
        \ let b:endwise_syngroups = 'djangoTagBlock,djangoStatement'
  autocmd FileType * call s:abbrev()
augroup END " }}}1

function! s:abbrev()
  if exists('g:endwise_abbreviations')
    for word in split(get(b:, 'endwise_words', ''), ',')
      execute 'iabbrev <buffer><script>' word word.'<CR><SID>DiscretionaryEnd<Space><C-U><BS>'
    endfor
  endif
endfunction

" Maps {{{1

function! EndwiseDiscretionary()
  return <SID>Endwise(0, 0)
endfunction

function! EndwiseAlways()
  return <SID>Endwise(1, 0)
endfunction

if maparg("<Plug>DiscretionaryEnd") == ""
  inoremap <silent> <SID>DiscretionaryEnd  <C-R>=<SID>Endwise(0, 1)<CR>
  inoremap <silent> <SID>AlwaysEnd         <C-R>=<SID>Endwise(1, 1)<CR>
  imap     <script> <Plug>DiscretionaryEnd <SID>DiscretionaryEnd
  imap     <script> <Plug>AlwaysEnd        <SID>AlwaysEnd
endif

if !exists('g:endwise_no_mappings')
  if maparg('<CR>','i') =~# '<C-R>=.*Endwise(.)<CR>\|<\%(Plug\|SNR\|SID\)>.*End'
    " Already mapped
  elseif maparg('<CR>','i') =~ '<CR>'
    exe "imap <script> <C-X><CR> ".maparg('<CR>','i')."<SID>AlwaysEnd"
    exe "imap <script> <CR>      ".maparg('<CR>','i')."<SID>DiscretionaryEnd"
  elseif maparg('<CR>','i') =~ '<Plug>\w\+CR'
    exe "imap <C-X><CR> ".maparg('<CR>', 'i')."<Plug>AlwaysEnd"
    exe "imap <CR> ".maparg('<CR>', 'i')."<Plug>DiscretionaryEnd"
  else
    imap <script> <C-X><CR> <CR><SID>AlwaysEnd
    imap <CR> <CR><Plug>DiscretionaryEnd
  endif
endif

" }}}1

" Code {{{1

function! s:mysearchpair(BeginPattern,EndPattern,SyntaxPattern)
  let g:endwise_syntaxes = ""
  let s:lastline = line('.')
  call s:synname()
  let line = searchpair(a:BeginPattern,'',a:EndPattern,'Wn','<SID>synname() !~# "^'.substitute(a:SyntaxPattern,'\\','\\\\','g').'$"',line('.')+50)
  return line
endfunction

function! s:Endwise(always, interactive)

  let OnFailure = ''
  let OnSuccess = ''

  if !exists("b:endwise_addition") || !exists("b:endwise_words") || !exists("b:endwise_syngroups")
    return OnFailure
  end

  let SyntaxPattern  = '\%(' . substitute(b:endwise_syngroups, ',', '\\|', 'g') . '\)'
  let WordChoice = '\%(' . substitute(b:endwise_words, ',', '\\|', 'g') . '\)'

  if exists("b:endwise_pattern")
    let BeginPattern = substitute(b:endwise_pattern, '&', substitute(WordChoice, '\\', '\\&', 'g'), 'g')
  else
    let BeginPattern = '\<' . WordChoice . '\>'
  endif

  " In interactive contexts, we need to look at the previous line.
  " This is because this function would get called after the insertion
  " of <CR>.
  let LineNumber = line('.') - a:interactive
  let Line = getline(LineNumber)

  let Indent  = matchstr(Line, '^\s*')
  let Column  = match(Line, BeginPattern) + 1
  let Word    = matchstr(Line, BeginPattern)
  let EndWord = substitute(Word, '.*', b:endwise_addition, '')

  let OnSuccess = OnFailure . EndWord

  " For interactive use, we want to exit insert mode and then
  " plonk a newline in.
  if a:interactive
    let OnSuccess .= "\<C-O>O"
  endif

  if b:endwise_addition[0:1] ==# '\='
    let EndPattern = '\w\@<!' . EndWord . '\w\@!'
  else
    let EndPattern = '\w\@<!' . substitute('\w\+', '.*', b:endwise_addition, '') . '\w\@!'
  endif

  " Don't do lookarounds if 'always' is truthy
  if a:always
    return OnSuccess
  endif

  if Column <= 0
    return OnFailure
  endif

  let SyntaxID = synIDattr(synID(LineNumber, Column, 1), 'name')
  if SyntaxID !~ '^' . SyntaxPattern . '$'
    return OnFailure
  endif

  let PairedRow = s:mysearchpair(BeginPattern, EndPattern, SyntaxPattern)
  let PairedLine = getline(PairedRow)

  let NeedsIndent = strlen(matchstr(PairedLine, '^\s*')) < strlen(Indent)
  if PairedRow == 0
    let NeedsIndent = 1
  endif

  if NeedsIndent && PairedRow == line('.') + a:interactive
    return OnSuccess
  endif

  if !NeedsIndent
    return OnFailure
  endif

  return OnSuccess

endfunction

function! s:synname()
  " Checking this helps to force things to stay in sync
  while s:lastline < line('.')
    let s = synIDattr(synID(s:lastline,indent(s:lastline)+1,1),'name')
    let s:lastline = nextnonblank(s:lastline + 1)
  endwhile

  let s = synIDattr(synID(line('.'),col('.'),1),'name')
  let g:endwise_syntaxes = g:endwise_syntaxes . line('.').','.col('.')."=".s."\n"
  let s:lastline = line('.')
  return s
endfunction

" }}}1

" vim:set sw=2 sts=2:
