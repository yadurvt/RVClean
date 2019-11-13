
I have changed the first line

script "RVClean_behaviour"
global \
      gTextStart, \
      gTextEnd, \
      now_selected, \
      to_highlight, \
      highlight_group, \
      \
      --COmments on 13.11.19
      search_category, \
      separator, \
      citation_style, \
      the_journal, \
      the_view, \
      view_style, \
      the_file, the_directory, file_root, file_extension, \
      gUndoHistory, \
      edited, \
      undo_count, \
      gConnectionID, gTableName, the_choice, gWholeTable, gColumns, \
      gTableName, \
      gPatternTableName, \
      gBugTableName, \
      \
      gColumns, \
      filter_name, \
      search_name, \
      text_before, \
      text_before_option, \
      search_string, \
      gFull_search_string, \
      text_after, \
      text_after_option, \
      replace_string, \
      search_zone, \
      search_category, \
      ignore_case, \
      whole_word, \
      Multiline, \
      filter_ID, \
      gHiliteFrom, \
      gHiliteTo, \
      gPreviousHiliteTo, \
      gPreviousHiliteFrom, \
      gCompactScroll, \
      gStart, \
      gEnd, \
      gSortedFilterList, \
      gColorLength, \
      gEndLength, \
      gColorTagRegex, \
      gEndTagRegex, \
      gSearchGroup, \
      gSearchField, \
      gReplaceField, \
      gSearchMode, \
      gSelectionChars, \
      gPatternsA, \
      sPatternColumns, \
      gBugVariables, \
      gDoNotAbbreviate, \
      gActiveField

global \
      citation_text_color, \
      heading_text_color, \
      citation_text_style, \
      heading_text_style, \
      original_bg_color, \
      replace_bg_color, \
      gGoogleDataSheet


local sNumberFound, \
      sStarTag, \
      sWhiteStar, \
      s_Start, \
      s_End, \
      sBeginTagRegex, \
      sEndTagRegex, \
      sText, \
      sCleanUpPatterns, \
      sOriginalTextColor, \
      sSelectionStart, \
      sSelectionEnd, \
      sCleanUpItem, \
      sReplacementTextColor, \
      sCleanUpColors, \
      sNowProcessing, \
      sPatterns,  \
      sScopes, \
      sScopeTagA, \
      sPatternTagA, \
      sCurrentScope, \
      sCurrentScopeTag, \
      sScopeBeginTag, \
      sScopeEndTag, \
      sPublishers, \
      sDiacritics, \
      sJournals, \
      sPrefixes, \
      sFillerWords, \
      sCountries, \
      sPatternsA, \
      sPatternOrder, \
      sTagsInPrelims, \
      sHeadersA, \
      sSurnames

global sPatternColumns

local sRefs, \
      sOriginalRefs, \
      sCleanedRefs, \
      sRefsNoDiacritic, \
      sTheTop, \
      sTheBottom, \
      \
      sOption, \
      sKey, \
      sRef_type, \
      sAuthors, \
      sAtitle, \
      sJtitle, \
      sVolume, \
      sIssue, \
      sYear, \
      sYearSuffix, \
      sEditors, \
      sEditortag, \
      sFpage, \
      sLpage, \
      sBibchap, \
      sDOI, \
      sPbibdoi, \
      sPost, \
      sArxiv, \
      sOtitle, \
      sMisc, \
      sBktitle, \
      sBktitle_cont, \
      sBkstitle, \
      sPublisher, \
      sEdition, \
      sReport, \
      sOrg, \
      sPlace, \
      sRefItemsA, \
      sSuspectMark, \
      sSuspectJnlMark

local sRegexp, \
      sExtracted, \
      sAu_order, \
      sAu_order_1st, \
      sAu_Case, \
      sAu_Minor_Sep_1st, \
      sAu_Minor_Sep, \
      sAu_Major_Sep, \
      sAu_Prefix, \
      sAu_Suffix
      
      
      
-- Comment added for test
-- Kaveh's comments for testing

on openstack
   put the millisecs into ms
   if the short name of this stack is not "RVClean" then
      -- must be a substack
      exit openstack
   end if
   --   ask "Please enter you name"
   ensure_locked
   set the cursor to watch
   choose browse tool
   read_settings
   put "——————————————————————————————————————————————————————————" \
         into separator
   put "" into gUndoHistory
   put fld "undo_s" of stack settings into no_of_undo_s
   put 1 into undo_count
   check_for_undo
   get_remote_prefs
   _define_color_tags
   put "https://docs.google.com/spreadsheets/d/1gJhRbnCqApsVEZ74apcT6sWlN3fZKhZdHBbdfr5Yk2Q/edit#gid=1454732811"\
         into gGoogleDataSheet
   import_data
   put empty into s_Start
   put empty into s_End
   put "255,0,0" into sOriginalTextColor
   put "1,71,250" into sReplacementTextColor
   -- get mk_getprefs() -- read prefs from local system
   put "(" &  \
         "[①②③④⑤⑥]" & \
         sStarTag &  \
         ")" \
         into sBeginTagRegex
   put "(" &  \
         sStarTag & \
         "[①②③④⑤⑥]" &   \
         ")"  \
         into sEndTagRegex
   put "•£•" into sSuspectMark
   put "•€•" into sSuspectJnlMark
   save_regex_for_fields
   -- À-ÿ: accented characters
   -- Α-϶: greek characters. NB "Α" is not normal A
   -- just copied letters from this page:
   -- https://en.wikipedia.org/wiki/Greek_and_Coptic
   -- and it seems to work
   set the cWordChars of fld Unstructured to "[-–.@:/0-9A-Za-zÀ-ÿΑ-϶]"
   put sorted_filter_list() into gSortedFilterList
   start using font file "/Users/kaveh/Library/Fonts/Entypo.ttf"
   start using font file "/Users/kaveh/Library/Fonts/FontAwesome.ttf"
   --
   put the long name of group "Search and replace" into gSearchGroup
   put the long name of fld "Search" of gSearchGroup into gSearchField
   put the long name of fld "Replace" of gSearchGroup into gReplaceField
   --
   --   get apply_filter_tags("Search text")
   --   get apply_filter_tags("Replace text")
   
   --   send update_patterns to stack "patterns"
   
   define_pattern_columns
   define_bug_columns
   set the label of btn "User" to it
   --   update_patterns
   --   do_find
   unlock screen
   --   answer the millisecs - ms
end openstack

on _define_color_tags
   put "①,②,③,④,⑤,⑥,⑦,⑧,⑨,⑩,⑪,⑫,⑬,⑭,⑮,⑯" \
         into sPatternTagA
   split sPatternTagA by comma -- make it into an array
   put "ⓐ,ⓑ,ⓒ,ⓓ,ⓔ,ⓕ,ⓖ,ⓗ,ⓘ,ⓙ,ⓚ,ⓛ,ⓜ,ⓝ,ⓞ,ⓟ,ⓠ,ⓡ,ⓢ,ⓣ,ⓤ,ⓥ,ⓦ,ⓧ,ⓨ,ⓩ"  \
         into sScopeTagA
   split sScopeTagA by comma -- make it into an array
   put "★" into sStarTag
   put "☆" into sWhiteStar
end _define_color_tags


on define_pattern_columns
   put "Pattern_name",  \
         "Ref_type",  \
         "Example", \
         "Search_pattern",  \
         "Extracted", \
         "Au_order_1st", \
         "Au_order",  \
         "Au_case",  \
         "Au_minor_sep_1st", \
         "Au_minor_sep",  \
         "Au_major_sep",  \
         "Au_prefix",  \
         "Au_suffix" \
         into sPatternColumns
end define_pattern_columns

on define_bug_columns
   put "bug_ID", \
         "file_name", \
         "ref_key",  \
         "Description", \
         "User",  \
         "the_Date", \
         "Feedback_type", \
         "bug_status"  \
         into gBugVariables
end define_bug_columns

----------------------------------------------------------
--------------------- Begin pref file section ------------
----------------------------------------------------------

function mkprefsfolder
   -- for full explanation see:
   -- http://newsletters.livecode.com/october/issue99/newsletter3.php
   --
   ## Check the platform to decide where to store the file(s)
   switch the platform
      case "MacOS"
         
         ## The folder "Preferences" in the current users
         # "Library" folder:
         put specialFolderPath("preferences") into spfp
         break
      case "Win32"
         
         ## Everything >= Win2000
         if the systemversion contains "NT" then
            put specialFolderPath(26) into spfp
         else
            
            ## Win95, 96, 97, 98, 98ME and 99 :-)
            ## Should be something like C:/System
            ## But I am not sure...
            put specialfolderpath("system") into spfp
         end if
         break
      default
         
         ## Linux
         ## The current users HOME folder
         put $HOME into spfp
         break
   end switch
   
   if there is not a folder (spfp & "/RVClean") then
      create folder (spfp & "/RVClean" )
   end if
   
   ## Return the path including trailing SLASH, ready for use!
   return (spfp & "/RVClean/")
end mkprefsfolder

function mk_getprefs
   ## This function will return the content of our previously
   # saved prefs file or EMPTY,
   ## if the file has not yet been saved!
   put mkprefsfolder() into tPath
   if there is a file (tPath & "search_items.txt") then
      return url("file:" & tPath & "search_items.txt")
   else
      ## not yet saved
      return empty
   end if
end mk_getprefs

function mk_setprefs tPrefs
   ## This finction will write the complete prefs to the above
   # mentioned file:
   ## This could also be a HANDLER but making it a finction we can
   # check if the writing
   ## of the text file did not encounter any error!
   
   put mkprefsfolder() into tPath
   
   put "Lorem ipsum dolor sit amet" into tPrefs
   
   ## We write the prefs "en bloc" to the file
   put tPrefs into url("file:" & tPath & "search_items.txt")
   
   ## This will be empty if everything is OK, but will contain
   # a hint on what might have gone wrong
   return the result
end mk_setprefs

on write_to_file pFileName pText
   put mkprefsfolder() into tPath
   put pText into url("file:" & tPath & pFileName)
end write_to_file


on open_the_file pPath
   -- put my_path into pPath
   set the itemdelimiter to "/"
   put pPath into the_directory
   put empty into the last item of the_directory
   put last item of pPath into the_file --e.g. FLM123.tex
   put the_file into file_root
   put replacetext( \
         file_root, \
         "(\d.+)" , \
         ""\
         ) \
         into tJournal
   put toUpper(tJournal) into tJournal
   set the label of btn "Journal" to tJournal
   delete char -1 to -4 of file_root -- remove extension
   -- put replacetext(the_file, "(\.tex)", "") into file_root -- e.g. FLM123
   put replacetext(the_file, "(^.+\.)", "") into file_extension
   -- following line ensures unicode text recognized
   open file pPath for "utf-8" text read
   read from file pPath until EOF
   if file_extension is "html" or \
         file_extension is "htm" \
         then
      -- set the htmltext of fld "Main text" to the htmltext of it
   else if file_extension is "rtf" then
      -- set the rtftext of fld "Main text" to the rtftext of it
   else
      set the cOriginalText of fld "Main text" to it
      put it into fld "Main text"
      put it into fld "Unstructured"
      put empty into fld "Structured"
   end if
   put the_file into fld "File name"
   put the_directory into fld "Directory"
   show_full_text
   set the label of btn "View option" to "Full text"
   -- style_text
   reset_undo
   check_for_undo
   write_undo_file
   write_file_data
   --   _style_for_clean_up
end open_the_file

on write_file_data
   put the number of lines of fld "Main text" into fld "lines"
   put the number of chars of fld "Main text" into fld "chars"
end write_file_data


on ensure_locked
   if the lockscreen is not true then lock screen
end ensure_locked

on remove_all_styles
   ensure_locked
   put the vscroll of fld "Main text" into tScroll
   put remove_isolation_tags(fld "Main text") into fld "Main text"
   set the vscroll of fld "Main text" to tScroll
   -- unlock screen
end remove_all_styles

on update_view
   put the millisecs into ms
   ensure_locked
   
   if hilite of btn "Compact view" is true then
      show_compact_text
   else
      show_full_text
   end if
   put the htmltext of fld "Main text" into fld "temp"
   -- unlock screen
end update_view

on update_view_style
   ensure_locked
   if view_style is "Plain" then
      remove_all_styles
   else
      if view_style is "Highlighted" then
         highlight_text
      end if
   end if
   -- unlock screen
end update_view_style


function remove_isolation_tags pText
   put the cIsolateBeginTag of group "Filters" into tIsolateBeginTag
   put the cIsolateEndTag of group "Filters" into tIsolateEndTag
   replace tIsolateEndTag with "" in pText
   replace tIsolateBeginTag with "" in pText
   return pText
end remove_isolation_tags

on show_full_text
   put the selectedChunk of fld "Main text" into tChunk
   set the lockText of fld "Main text" to false
   put the seconds into temp
   put the milliseconds into time_now
   -- remember selection and apply to full text view
   -- put word 2 of the selectedChunk of fld "Main text" into gTextStart
   -- put word 4 of the selectedChunk of fld "Main text" into gTextEnd
   -- hide fld "replacement"
   put the number of lines of fld "Main text" into total_lines
   
   set the hidden of line 1 to - 1 of fld "Main text" to false
   if separator is not empty \
         and the hilite of btn "Use separator"  is true then
      replace return & separator with "" in fld "Main text" \
            of stack "RVClean" preserving styles
   end if
   set the borderwidth of line 1 to -1 of fld "main text" to empty
   set the spaceabove of line 1 to -1 of fld "main text" to empty
   if tChunk is not empty then select tChunk
end show_full_text

on select_me
   get the cSelectedText of fld "Main text"
   if it is not empty then
      select it
   end if
end select_me

on show_compact_text
   put the selectedChunk of fld "Main text" into tChunk
   set the cSelectedText of fld "Main text" to tChunk
   set the hidden of line 1 to -1 of fld "Main text" to true
   hide fld "replacement" of stack "RVClean"
   put the seconds into temp
   
   -- for use of styledText see Kaveh's question and the replies here:
   -- http://lists.runrev.com/pipermail/use-livecode/2018-November/251753.html
   
   put the milliseconds into time_now
   put empty into s
   set linedelimiter to return & "<p"
   put the htmltext of fld "Main text" into ht
   replace "<p hidden" with "<p" in ht
   put return before ht -- to ensure first line is done right
   repeat for each line L in ht
      if offset("color=",L)>0 then
         put return & "<p" & L after s
         if separator is not empty and \
               the highlight of btn "Use separator" is true \
               then
            put return & separator & return after s
         end if
      else put "<p hidden" & L after s
   end repeat
   put empty into char 1 of ht -- remove the return
   set htmltext of fld "Main text" to s
   put the milliseconds - time_now into time_to_hide
   put "Hide time: " & time_to_hide into fld "time to show"
   --
   set the borderwidth of line 1 to -1 of fld "main text" to 1
   set the spaceabove of line 1 to -1 of fld "main text" to 2
   
   send "select_me" to me in .01 seconds
   --set the locktext of fld "Main text" to true
   -- ideally we need a better way of setting scroll
   -- so text is same position when going from expanded text
   --   set the scroll of fld "Main text" to gCompactScroll
end show_compact_text



on write_undo_file
   put the ticks into current_time
   put current_time & "," & return before gUndoHistory
   put file_root & "-" & current_time & "." & file_extension into tempfile
   put the_directory &"undo/" into backup_directory
   put backup_directory & tempfile into backup_file
   if there is not a folder backup_directory then
      create folder backup_directory
   end if
   open file backup_file for "utf-8" text write
   put the htmltext of fld "Main text" into tText
   write tText to file backup_file
   close file backup_file
   set the cText_has_changed of fld "Main text" to false
end write_undo_file

on undo_edit
   if undo_count > the number of items of gUndoHistory -2 then
      -- return at end of undo count makes it one line longer
      exit undo_edit
   end if
   put undo_count +1 into undo_count
   open_undo_file
   hide fld "replacement"
end undo_edit

on redo_edit
   if undo_count < 2 then
      exit redo_edit
   end if
   put undo_count -1 into undo_count
   open_undo_file
   hide fld "replacement"
end redo_edit

on open_undo_file
   -- to avoid several undo commands queuing up when
   -- "u" or "r" are held down:
   lock messages
   put the vscroll of fld "Main text" into tScroll
   get item undo_count of gUndoHistory
   put replacetext(it, return, "") into it
   put file_root & "-" & it & "." & file_extension into tempfile
   put the_directory &"undo/"& tempfile into to_retrieve
   open file to_retrieve for read
   read from file to_retrieve until EOF
   set the htmltext of fld "Main text" to it
   --   if view_style is "highlighted" then
   --      highlight_text
   --   end if
   --   if hilite of btn "Compact view" is true then
   --      show_compact_text
   --   end if
   set the vscroll of fld "Main text" to tScroll
end open_undo_file


on check_for_undo
   --   exit check_for_undo
   if the cText_has_changed of fld "Main text" then
      write_undo_file
   end if
   send "check_for_undo" to me in 5 seconds
end check_for_undo

on reset_undo
   put 0 into undo_count
   put empty into gUndoHistory
end reset_undo

on mouseup
   if the short name of the owner of the target is "To highlight" then
      if the highlight of btn "Highlighted" is true then
         highlight_text
      end if
      pass mouseup
   end if
   if the short name of \
         the owner of the target is "Items to clean up" then
      _style_for_clean_up
   end if
end mouseup

function convert_field_to_regexp pFilter, pText
   -- only use function if "Regexp" is not checked
   if the hilite of btn "Regexp" of group pFilter is not true then
      put force_to_regexp(pText) into pText
   end if
   return pText
end convert_field_to_regexp

function force_to_regexp pText
   put replacetext(pText, "(\\)", "\\") into pText
   put replacetext(pText, "(\[)", "\[") into pText
   put replacetext(pText, "(\])", "\]") into pText
   put replacetext(pText, "(\{)", "\{") into pText
   put replacetext(pText, "(\})", "\}") into pText
   put replacetext(pText, "(\.)", "\.") into pText
   put replacetext(pText, "(\()", "\(") into pText
   put replacetext(pText, "(\))", "\)") into pText
   put replacetext(pText, "(\+)", "\+") into pText
   put replacetext(pText, "(\-)", "\-") into pText
   put replacetext(pText, "(\^)", "\^") into pText
   put replacetext(pText, "(\$)", "\$") into pText
   put replacetext(pText, "(\*)", "\*") into pText
   put replacetext(pText, "(\?)", "\?") into pText
   put replacetext(pText, "(\|)", "\|") into pText
   return pText
end force_to_regexp

on structure_references
   extract_references
   _structure_refs_just_imported
   set the cNowProcessing of group "Structuring" to "References"
end structure_references

on extract_references
   put empty into tIgnore
   put empty into tExtractStart
   put empty into tExtractEnd
   put fld "Main text" into tText
   get matchchunk(tText, \
         "(?s)((?<=\n)\s*\\begin{thebibliography}.+?(?=\n))", \ --         "(\\bibitem)", \
         tIgnore, \
         tExtractStart)
   get matchchunk(tText, \
         "(?s)((?<=\n)\s*\\end{thebibliography})", \
         tExtractEnd, \
         tIgnore)
   put tExtractStart +1 into tExtractStart
   put tExtractEnd - 1 into tExtractEnd
   set the cExtractStart of fld "Main text" to tExtractStart
   set the cExtractEnd of fld "Main text" to tExtractEnd
   put char tExtractStart to tExtractEnd of tText into tText
   -- put return before \indent (some refs don't have double return)
   put _insert_return_before_slash_indent(tText) into tText
   -- if no key then remove \bibitem so new key generated
   put _remove_bibitem_if_no_key(tText) into tText
   put _multiple_returns_to_three_returns(tText) into fld "Unstructured"
   show_structuring
end extract_references

function _remove_bibitem_if_no_key pText
   put replacetext(pText, "(?is)(\\bibitem(\[[^\[\]]+?\])?\s*({\s*})\n)", "") into pText
   return pText
end _remove_bibitem_if_no_key

function _insert_return_before_slash_indent pText
   put replacetext(pText, "(?s)(\n\\indent)", return&return & "\indent") into pText
   return pText
end _insert_return_before_slash_indent

function _remove_leading_returns pText
   put replacetext(pText, "(?s)(^\n+)", "") into pText
   return pText
end _remove_leading_returns


on show_structuring
   show group "Structuring"
   --   set the label of btn "Structuring" to "Hide structuring"
end show_structuring

on hide_structuring
   hide group "Structuring"
   --   set the label of btn "Structuring" to "Hide structuring"
end hide_structuring


on dragDrop
   put the dragData into my_path
   get matchText( \
         my_path, \
         "(...$)", \
         file_extension\
         )
   if file_extension is not "tex" and \
         file_extension is not "txt" then
      answer "Please import a .tex or .txt file"
      exit dragDrop
   end if
   open_the_file my_path
   -- refresh
end dragDrop

function convert_to_hex pMyColor
   -- see https://forums.livecode.com/viewtopic.php?t=17143
   put empty into tMyHexColor
   repeat with x = 1 to the number of items in pMyColor
      put baseconvert(item x of pMyColor,10,16) into tHex
      if the number of chars in tHex < 2 then
         put "0" before tHex
      end if
      put tHex after tMyHexColor
   end repeat
   put "#" before tMyHexColor
   return tMyHexColor
end convert_to_hex

function wordWrapped pMaxLength
   local tWrappedText
   -- copied from: http://bit.ly/2AggXzk
   /*
   This function has been modified by Kaveh so that line wrapping is done,
   but only on portions not highlighted. So by highlighting all
   display equations we can ensure that equations are not hard wrapped,
   and long lines are kept as they are.
   */
   if pMaxLength is empty or pMaxLength is not a number then
      ## use a default value if maxLength is not provided
      put 75 into pMaxLength
   end if
   
   if pMaxLength is not an integer then
      ## truncate it
      put trunc(pMaxLength) into pMaxLength
   end if
   put fld "Main text" into tText
   put the htmltext of fld "Main text" into tHTML
   put 0 into tLine_number
   repeat for each line tLine in tText
      put tLine_number + 1 into tLine_number
      put line tLine_number of tHTML into tHTML_line
      if (length(tLine) <= pMaxLength) \
            OR (offset(" bgcolor=",line tLine_number of tHTML)>0) \
            then
         ## the line is shorter than the maximum,
         ## OR there is some bgcolor in line
         put tLine & return after tWrappedText
      else if matchtext(tLine, "^ *%") is true \
            then
         ## comment line and it is a tex file. We must always be
         ## aware not all files are tex so the handlers have to
         ## be general
         put tLine & return after tWrappedText
      else
         ## tLine is longer than the maximum
         repeat until tLine is empty
            ## try to break the line at a space
            repeat with x = pMaxLength down to 1
               if char x of tLine is space or \
                     length(tLine) < pMaxLength then
                  put (char 1 to x-1 of tLine) & \
                        return after tWrappedText
                  delete char 1 to x of tLine
                  exit repeat
               end if
            end repeat
            if x = 1 then
               ## no spaces in the first pMaxLength chars
               ## so we break it at that number of characters
               put char 1 to pMaxLength of tLine & return after tWrappedText
               delete char 1 to pMaxLength of tLine
            end if
         end repeat
      end if
   end repeat
   return tWrappedText
end wordWrapped

on do_live_search
   ensure_locked
   -- if there is a selection, we can reset that selection after search
   put the selectedChunk of fld "Main text" into tChunk
   put the milliseconds into tTimeNow
   if the cText_has_changed of fld "Main text" is false then
      -- no key pressed since handler was last called
      exit do_live_search
   end if
   if the label of btn "View option" is "Full text" then
      save_scroll
   end if
   --
   put (fld "Type delay" of stack "settings") * 1000 into tTypeDelay
   if (tTimeNow - the cWhen_text_changed of fld "Main text") \
         > tTypeDelay then
      do_find
      set the cText_has_changed of fld "Main text" to false
   else
      -- check regularly to see if time to search
      put fld "Find delay" of stack "settings" into tFindDelay
      send "do_live_search" to me in tFindDelay seconds
   end if
   if the label of btn "view option" is "Full text" then
      reset_scroll
   end if
   if tChunk is not empty then
      select tChunk
   end if
   -- unlock screen
end do_live_search


--on make_me_active
-- /**
-- For fields: "Search", "Text before", "Text after"
-- note 3 levels of grouping. if this grouping level changes
-- then Handler will not work, so need to take care. Perhaps there is a better
-- way than hard coding exact level of grouping
-- **/
-- put the short name of the owner \
-- of the owner \
-- of the owner of target \
-- into gActiveFilter
-- put the short name of the target into gActiveSearchField
--end make_me_active

--on mark_me_for_edit
-- put the short name of the owner \
-- of the owner \
-- of the owner of target \
-- into gFilterBeingEdited
-- put the short name of the target into gFieldBeingEdited
-- put gFilterBeingEdited into gActiveFilter
-- put gFieldBeingEdited into gActiveSearchField
--end mark_me_for_edit


function style_text pText
   -- insert tags e.g.
   -- ①★dolor★①
   -- but do not put tags at start and end of each para
   put pText into tStyledText
   -- remove temporary tags used to isolate filters
   --   put remove_isolation_tags(tStyledText) into tStyledText
   --   put remove_confusing_tags(tStyledText) into tStyledText
   --
   put the millisecs into ms
   repeat for each line L in gSortedFilterList
      put L into tFilter
      if fld "search" of group tFilter is empty then
         put empty into fld "Count" of group tFilter
         put empty into fld "Milliseconds" of group tFilter
         next repeat
      end if
      put highlight_search_item(tStyledText, tFilter) into tStyledText
   end repeat
   
   
   set the cAppliedChanges of fld "Search" of gSearchGroup to tStyledText
   set the cStyledText of fld "Main text" to tStyledText
   put tStyledText into fld "temp found"
   put the millisecs - ms into fld "styled"
   return tStyledText
end style_text

function focus_view pStyledText
   put gSortedFilterList into tList
   put the label of btn "View option" into tViewOption
   switch tViewOption
      case "Full text"
         return pStyledText
         break
      case "Isolate last filter"
         put line -1 of tList into tFilter
         put isolate_filter(tFilter, pStyledText) into pText
         break
      case "Isolate last two filters"
         if the number of lines of gSortedFilterList is 1 then
            set the label of btn "View option" to "Isolate last filter"
            put line -1 of tList into tFilter
         else
            put line -2 of tList into tFilter
         end if
         put isolate_filter(tFilter, pStyledText) into pText
         break
   end switch
   return pText
end focus_view

function styled_to_html pText
   put pText into tStyledText
   --   put close_tags_for_each_line(tStyledText) into tStyledText
   put convert_temp_Tags_to_html(tStyledText) into tHTMLText
   --   put convert_search_tags_to_html(tHTMLText) into tHTMLText
   --   put convert_replace_tags_to_html(tHTMLText) into tHTMLText
   put p_tags_insert(tHTMLText) into tHTMLText
   if the label of btn "View option" is not "Full text" then
   end if
   return tHTMLText
end styled_to_html


on do_find
   ensure_locked
   lock messages
   if gSortedFilterList is empty then
      -- nothing to highlight
      put fld "Main text" into fld "Main text" -- remove styles
      set the cStyledText of fld "Main text" to fld "Main text"
      exit do_find
   end if
   if is_all_regex_valid() is false then
      exit do_find
   end if
   if the visible of grp "Search and replace" is true then
      put the cUnappliedChanges of gSearchGroup into tStyledText
      -- put the long name of fld "isolate" into tTextField
   else
      put style_text(fld "Main text") into tStyledText
      -- put the long name of fld "Main text" into tTextField
   end if
   put focus_view(tStyledText) into tFocusedText
   put tFocusedText into fld "temp found"
   put styled_to_html(tFocusedText) into tHTMLText
   -- if label of btn "View option" is "Show paras with highlights" then
   -- show_compact_text
   --end if
   put tHTMLText into fld "temp"
   --
   --   if gSearchMode is true then
   if the visible of grp "Search and replace" is true then
      -- always show "isolate"
      set the HTMLText of fld "isolate" to tHTMLText
      show fld "isolate"
   else
      if the label of btn "View option" is "Full text" then
         set the HTMLText of fld "Main text" to tHTMLText
         hide fld "isolate"
      else
         set the HTMLText of fld "isolate" to tHTMLText
         show fld "isolate"
      end if
   end if
   -- unlock screen
end do_find

function is_all_regex_valid
   -- check all fields have valid regex
   repeat for each line L in gSortedFilterList
      put L into tFilter
      if fld "search" of group L is empty then next repeat
      put the cFullRegex of group L into tSearch
      if is_regex_correct(tSearch) is false then
         remove_all_styles
         return false
      end if
   end repeat
   return true
end is_all_regex_valid

on save_text_and_styledText
   -- put the cOriginalText of fld "Main text" into tText
   -- put style_text(tText) into tStyledText
   -- set the cStyledText of fld "Main text" to tStyledText
end save_text_and_styledText

function styled_to_plain_text pText
   put replacetext(pText, gColorTagRegex, "") into pText
   put replacetext(pText, gEndTagRegex, "") into pText
   return pText
end styled_to_plain_text

case "Show paras with highlights"
   show_compact_text
   break
   
   function insert_hidden_html_tags pText
      put empty into tResult
      repeat for each line L in pText
         if offset("••showthisline••", L) = 0 then
            replace "<p>" with "<p hidden>" in L
         end if
         put L & return after tResult
      end repeat
      replace "••showthisline••" with "" in tResult
      delete last char of tResult
      return tResult
   end insert_hidden_html_tags
   
   function remove_isolate_remainder_tags pText
      put the cIsolateBeginTag of group "Filters" into tIsolateBeginTag
      put the cIsolateEndTag of group "Filters" into tIsolateEndTag
      put char 7 to -1 of tIsolateBeginTag into tBeginRemainder
      put char 7 to -1 of tIsolateEndTag into tEndRemainder
      replace tBeginRemainder & return with "" in pText
      replace return & tEndRemainder with "" in pText
      return pText
   end remove_isolate_remainder_tags
   
   
   function close_tags_for_each_line pText
      put gSortedFilterList into tFilterList
      put the number of lines in tFilterList into tNumber
      -- Need to do in reverse order to get right hierarchy of colors
      repeat with L = tNumber down to 1
         put close_tag(pText, line L of tFilterList) into pText
      end repeat
   end close_tags_for_each_line
   
   function close_tag \
         pText, \
         tFilter
      put char 1 to -3 of the cBeginTag of group tFilter into tDelimiter
      -- e.g. •A1550520222350
      put the length of tDelimiter into tDelimiterLength
      -- this will be identical to char 1 to -3 of cEndTag
      set the linedelimiter to tDelimiter
      put the cColorTag of group tFilter into tColorTag
      put the cEndTag of group tFilter into tEndTag
      put the cMidTag of group tFilter into tMidTag
      put empty into tResult
      repeat for each line L in pText
         if offset(tMidTag, L) > 0 then
            put replacetext(L, \
                  "(\n)", \
                  tEndTag & return & tColorTag \
                  ) \
                  into tLineOut
         else
            put L into tLineOut
         end if
         put tDelimiter & tLineOut after tResult
      end repeat
      put empty into char 1 to tDelimiterLength of tResult -- extra tDelimiter at start
      return tResult
   end close_tag
   
   
   
   function construct_basic_regex pFilter
      put fld "Search" of group pFilter into tSearch
      put convert_field_to_regexp(pFilter, tSearch) into tSearch
      if the highlight of btn "Whole word" of group pFilter is true then
         put "\b" & tSearch & "\b" into tSearch
      end if
      -- add look behind
      if fld "Text before" of group pFilter is not empty then
         put "(?<" into tBehind
         if the label of btn "Text before option" of group pFilter is "=" then
            put "=" after tBehind
         else \
               if the label of btn "Text before option" of group pFilter is "≠" then
            put "!" after tBehind
         end if
         put convert_field_to_regexp(pFilter, fld "Text before" of group pFilter) after tBehind
         put ")" after tBehind
      end if
      -- add lookahead
      if fld "Text after" of group pFilter is not empty then
         put "(?" into tAhead
         if the label of btn "Text after option" of group pFilter is "=" then
            put "=" after tAhead
         else \
               if the label of btn "Text after option" of group pFilter is "≠" then
            put "!" after tAhead
         end if
         put convert_field_to_regexp(pFilter, fld "Text after" of group pFilter) after tAhead
         put ")" after tAhead
      end if
      put tBehind & tSearch & tAhead into tSearch
      put selected_modes(pFilter) before tSearch
      put tSearch into fld the_grep
      -- need (…) so that matchChunk remembers what it has found
      -- see matchChunk documentation
      return tSearch
   end construct_basic_regex
   
   function construct_full_regex pFilter
      return "(" & construct_basic_regex(pFilter) & ")"
   end construct_full_regex
   
   
   function selected_modes pFilter
      -- See https://www.regular-expressions.info/modifiers.html
      put "(?" into tRegexMode
      if the highlight of btn "Ignore case" of group pFilter is true then
         put "i" after tRegexMode
      end if
      if the highlight of btn "Multiline"of group pFilter is true then
         put "s" after tRegexMode
      end if
      put ")" after tRegexMode
      if the length of tRegexMode is 3 then put empty into tRegexMode
      return tRegexMode
   end selected_modes
   
   
   function highlight_search_item pText, pFilter
      put the millisecs into ms
      lock screen
      --
      put the cFullRegex of group pFilter into gFull_search_string
      put the cRGBcolor of group pFilter into tRGBColor
      put empty into fld "Found"
      
      put the label of btn "Search type" of \
            group pFilter into tSearchType
      -- how many found for each filter:
      put 0 into sNumberFound
      switch tSearchType
         case "Find"
            get __find(pFilter, pText)
            put it into tStyledText
            break
         case "Add"
            get __add(pFilter, pText)
            put it into tStyledText
            break
         case "Merge"
            get __merge(pFilter, pText)
            put it into tStyledText
            break
         case "Refine"
            get __refine(pFilter, pText)
            put it into tStyledText
      end switch
      put sNumberFound into fld "Count" of group pFilter
      put (the milliseconds - ms) into fld "milliseconds" of group pFilter
      -- unlock screen
      return tStyledText
   end highlight_search_item
   
   /**
   * apply_filter_tags
   * function
   *  pFilter :
   *  pTimeTag :
   * returns
   *
   */
   
   on apply_filter_tags
      -- set cFilterTag to ①,②,③, etc sequentially to filters
      put 0 into tLine
      repeat for each line L in gSortedFilterList
         put tLine + 1 into tLine
         set the cFilterTag of group L of group "filters" to sPatternTagA[tLine]
      end repeat
   end apply_filter_tags
   
   function __find pFilter, pText
      _get_tag_lengths
      put match_all_chunks(pFilter, pText) into tMatched
      return tMatched
   end __find
   
   --   function __merge pFilter pText
   --      put gSortedFilterList into tList
   --      reposition_filters_neatly
   --      put _previous_filter(pFilter) into tPreviousFilter
   --      put the cTimeTag of group tPreviousFilter into tTimeTag
   --      get apply_filter_tags(pFilter, tTimeTag)
   --      get __find(pFilter, pText)
   --      put it into tStyledText
   --      put gEndTag & \
   --            gBeginTag & \
   --            quote & pSearchColor & quote & \
   --            gMidTag \
   --            into tToDelete
   --      replace tTodelete with "" in tStyledText
   --      return tStyledText
   --   end __merge
   
   on _get_tag_lengths
      --   get length of group tags
      put the name of group 1 of group "Filters" into tfilter
      put the length of the cBeginTag of tFilter into sBeginLength
      put the length of the cEndTag of tFilter into sEndLength
      put the length of the cColorTag of tFilter into sColorLength
   end _get_tag_lengths
   
   function __add pFilter, pText
      put empty into tFinalText
      repeat forever
         put _grab_next_unstyled_text(pText) into tChunk
         if tChunk is empty then exit repeat
         put _shave_from_top(tChunk, pText)into pText
         put match_all_chunks(pFilter, tChunk) into tChunk
         put tChunk after tFinalText
         --
         put _grab_next_styled_text(pText) into tChunk
         put _shave_from_top(tChunk, pText)into pText
         put tChunk after tFinalText
      end repeat
      put pText after tFinalText
      return tFinalText
   end __add
   
   function __refine pFilter, pText
      put pText into tSourceText
      put empty into tFinalText
      repeat forever
         put _grab_next_unstyled_text(tSourceText) into tUnstyled
         put _shave_from_top(tUnstyled, tSourceText)into tSourceText
         put tUnstyled after tFinalText
         --
         put _styled_with_previous_filter(pFilter, tSourceText) into tStyled
         if tStyled is empty then
            exit repeat
         else
            put _shave_from_top(tStyled, tSourceText)into tSourceText
            put match_all_chunks(pFilter, tStyled) into tStyled
            put tStyled after tFinalText
         end if
      end repeat
      put tSourceText after tFinalText
      return tFinalText
   end __refine
   
   function _grab_next_unstyled_text pText
      put 0 into tStart; put 0 into tEnd
      --   Find first occurence of color tag
      get matchchunk( \
            pText, \
            sBeginTagRegex, \
            tStart, \
            tEnd \
            )
      if tStart = 0 then
         return pText
      end if
      put tStart - 1 into tStart
      -- if offset is 1, we choose char 0 to 0 which is empty but ok
      put char 1 to tStart of pText into tUnstyled_text
      return tUnstyled_text
   end _grab_next_unstyled_text
   
   function _grab_next_styled_text pText
      put 0 into tStart; put 0 into tEnd
      --   Find first occurence of color tag
      get matchchunk( \
            pText, \
            sBeginTagRegex, \
            tStart, \
            tEnd \
            )
      if tStart = 0 then
         return pText -- no styled text found
      end if
      
      --   put tStart - 1 into tStart
      -- if offset is 1, we choose char 0 to 0 which is empty but ok
      put char tStart to tStart of pText into tCurrentTag
      put tStart into tVeryStart
      -- get matching end tag:
      put "(" & sStarTag & tCurrentTag & ")" into tEndSearch
      get matchchunk( \
            pText, \
            tEndSearch, \
            tStart, \
            tEnd \
            )
      put char tVeryStart to tEnd of pText into tStyled_text
      return tStyled_text
   end _grab_next_styled_text
   
   
   function _styled_with_previous_filter pFilter, pText
      put _previous_tag(pFilter) into tPreviousTag
      put "((?s)" &  \
            tPreviousTag & \
            sStarTag & \
            ".+?" & \
            sStarTag & \
            tPreviousTag & \
            ")" \
            into tFind
      --
      put 0 into tStart; put 0 into tEnd
      get matchchunk( \
            pText, \
            tFind, \
            tStart, \
            tEnd \
            )
      if tStart = 0 then
         return empty
      end if
      put char tStart to tEnd of pText into tFound
      return tFound
   end _styled_with_previous_filter
   
   function _text_styled_with_any_filter pText
      put char 3 to 15 of pText into tTimeTag -- TimeTag of next filter
      put "•A" & tTimeTag & "C•" into tEndTag -- matching end tag
      put offset(tEndTag, pText) into tEndOffset
      put tEndOffset -1 + 17 into tEndOffset
      put char 1 to tEndOffset of pText into tFound
      return tFound
   end _text_styled_with_any_filter
   
   function _not_styled_with_last_filter pText
      put last line of gSortedFilterList into tFilter
      put the cColorTag of group tFilter into tColorTag
      put offset(tColorTag, pText) into tBeginOffset
      put tBeginOffset -1 into tBeginOffset
      put char 1 to tBeginOffset of pText into tFound
      return tFound
   end _not_styled_with_last_filter
   
   function _styled_with_last_filter pText
      put last line of gSortedFilterList into tFilter
      put the cEndTag of group tFilter into tEndTag
      put offset(tEndTag, pText) into tEndOffset
      put tEndOffset -1 + 17 into tEndOffset
      put char 1 to tEndOffset of pText into tFound
      return tFound
   end _styled_with_last_filter
   
   function _shave_from_top tToShave, tText
      get the length of tToShave
      put empty into char 1 to it of tText
      return tText
   end _shave_from_top
   
   function match_all_chunks pFilter, pText
      put the millisecs into ms
      put empty into tNewText
      --      put 100000 into rep
      put empty into tStart; put empty into tEnd
      put the cFilterTag of group pFilter into tTag
      put the cFullRegex of group pFilter into tFind
      
      repeat forever
         get matchChunk( \
               pText, \
               tFind, \
               tStart, \
               tEnd \
               )
         if tStart is empty then
            exit repeat -- no more to be found
         end if
         --
         put char 1 to tStart-1 of pText after tNewText
         put char tStart to tEnd of pText into tToTag
         put empty into char 1 to tEnd of pText
         put tTag & sStarTag & \
               tToTag & \
               sStarTag & tTag \
               after tNewText
         put empty into tStart; put empty into tEnd
      end repeat
      --   put sNumberFound +i -1 into sNumberFound
      -- last bit with left in orginal_text no matches:
      put pText after tNewText
      --   answer the millisecs - ms
      return tNewText
   end match_all_chunks
   
   
   --   function match_all_chunks pFilter, pText
   --      put the millisecs into ms
   --   put empty into tNewText
   --   put 0 into sNumberFound
   --   put the cFilterTag of group pFilter into tTag
   --   put the cBasicRegex of group pFilter into tFind
   --   -- not already tagged
   --   put "(?<!★)(" & tFind & ")(?!★)" into tFind
   --   repeat until matchChunk( \
   --         pText, \
   --         tFind, \
   --         s_Start, \
   --         s_End \
   --         ) \
   --         is false
   --      put "★" & tTag after char s_End of pText
   --      put tTag & "★" before char s_Start of pText
   --      put sNumberFound + 1 into sNumberFound
   --   end repeat
   --   answer the millisecs - ms
   --   return pText
   --end match_all_chunks
   
   function _has_color_tags pText
      put char 1 to 41 of pText into tStartText
      return matchtext(tStartText, gColorTagRegex)
   end _has_color_tags
   
   
   function _previous_color_tag pFilter
      put _previous_filter(pFilter) into tPreviousFilter
      put the cTimeTag of group tPreviousFilter into tPreviousTimeTag
      put the cRGBcolor of \
            group tPreviousFilter into tPreviousColor
      put convert_to_hex(tPreviousColor) into tPreviousColor
      put "•A" & tPreviousTimeTag & "B•" into tPreviousBeginTag
      put "•B" & tPreviousTimeTag & "C•" into tPreviousMidTag
      put tPreviousBeginTag & \
            tPreviousColor & \
            tPreviousMidTag \
            into tPreviousColorTag
      return tPreviousColorTag
   end _previous_color_tag
   
   function _previous_tag pFilter
      put _previous_filter(pFilter) into tFilter
      put the cFilterTag of group tFilter into tPreviousTag
      return tPreviousTag
   end _previous_tag
   
   function isolate_filter pFilter, pText
      put the cColorTag of group pFilter into tColorTag
      put the cEndTag of group pFilter into tEndTag
      put "((?is)" & \
            tColorTag & \
            ".+?" & \
            tEndTag & \
            ")" \
            into tToFind
      put empty into tIsolatedText
      put empty into tStart
      put empty into tEnd
      repeat forever
         get matchchunk( \
               pText, \
               tToFind, \
               tStart, \
               tEnd \
               )
         if it is false then
            exit repeat
         end if
         put char tStart to tEnd of pText after tIsolatedText
         put empty into char tStart to tEnd of pText
         put return after tIsolatedText
      end repeat
      return tIsolatedText
   end isolate_filter
   
   function _previous_filter pFilter
      put gSortedFilterList into tFilters
      put lineoffset(pFilter, tFilters) into tWhichFilter
      --unless it is first line:
      if tWhichFilter <>1 then
         put line tWhichFilter - 1 of tFilters into tPreviousFilter
         return tPreviousFilter
      end if
   end _previous_filter
   
   function next_filter pFilter
      put gSortedFilterList into tFilters
      put lineoffset(pFilter, tFilters) into tWhichFilter
      -- unless it is last line:
      if tWhichFilter <> line -1 of tFilters then
         put line tWhichFilter + 1 of tFilters into tNextFilter
         return tNextFilter
      end if
   end next_filter
   
   function _previous_color pFilter
      put _previous_filter(pFilter) into tPreviousFilter
      put the cFilterTag of \
            group tPreviousFilter into tPreviousTag
      put convert_to_hex(tPreviousColor) into tPreviousColor
      return tPreviousColor
   end _previous_color
   
   
   function convert_temp_Tags_to_html pText
      ensure_locked
      put gSortedFilterList into tList
      repeat for each line i in tList
         put i into tFilter
         --
         
         put the cFilterTag of group tFilter into tFilterTag -- e.g. ①
         put tFilterTag & sStarTag into tBeginTag -- e.g. ①★
         put sStarTag & tFilterTag into tEndtag -- e.g. ★①
         
         --
         put the "<font bgcolor=" & \
               the cHexColor of group tFilter & \
               ">" into tBeginReplace
         put replacetext (pText, tBeginTag,tBeginReplace) into pText
         put replacetext (pText, tEndTag, "</font>") into pText
         --
      end repeat
      -- Search and replace tags:
      --   put the cTimeTag of fld "Search" of gSearchGroup into tTime
      
      --   put the cBeginTag of grp "Search text" of gSearchGroup into tBeginTag
      --   put the cMidTag of grp "Search text" of gSearchGroup into tMidTag
      --   put the cEndTag of grp "Search text" of gSearchGroup into tEndTag
      --   --
      --   replace tBeginTag with "<font bgcolor=" in pText
      --   replace tMidTag with ">" in pText
      --   replace tEndTag with "</font>" in pText
      --
      return pText
      unlock screen
   end convert_temp_Tags_to_html
   
   function convert_search_tags_to_html tText
      put the cBeginTag of grp "Search text" of gSearchGroup into tBeginTag
      put the cMidTag of grp "Search text" of gSearchGroup into tMidTag
      put the cEndTag of grp "Search text" of gSearchGroup into tEndTag
      replace tBeginTag with "<font bgcolor=" in tText
      replace tMidTag with ">" in tText
      replace tEndTag with "</font>" in tText
      return tText
   end convert_search_tags_to_html
   
   function convert_replace_tags_to_html tText
      put the cBeginTag of grp "Replace text" of gSearchGroup into tBeginTag
      put the cMidTag of grp "Replace text" of gSearchGroup into tMidTag
      put the cEndTag of grp "Replace text" of gSearchGroup into tEndTag
      replace tBeginTag with "<font bgcolor=" in tText
      replace tMidTag with ">" in tText
      replace tEndTag with "</font>" in tText
      return tText
   end convert_replace_tags_to_html
   
   
   function is_regex_correct tSearch
      -- checks if regex is valid
      -- put construct_full_regex(gActiveSearchID) into tSearch
      try
         get matchChunk( \
               "abcd", \
               tSearch \
               )
      catch errNum
         put false into tResult
         return tResult
      end try
      -- otherwise regex is valid:
      return tResult
   end is_regex_correct
   
   function remove_confusing_tags pText
      replace "<" with "&lt;" in pText
      replace ">" with "&gt;" in pText
      return pText
   end remove_confusing_tags
   
   on style_search_field_for_bad_regex pFilter, pField
      set the backgroundcolor of fld pField of group pFilter to \
            the backgroundColor of fld "Regex error" of stack "settings"
   end style_search_field_for_bad_regex
   
   function p_tags_insert pText
      replace return with "</p>" & return & "<p>" in pText
      put "<p>" before pText
      put "</p>" after pText
      return pText
   end p_tags_insert
   
   function p_tags_remove pText
      replace "<p>" with empty in pText
      replace "</p>" with empty in pText
      return pText
   end p_tags_remove
   
   function _tag_it pText, pFilter
      put the cColorTag of group pFilter before pText
      put the cEndTag of group pFilter after pText
      return pText
   end _tag_it
   
   on reposition_filters_neatly
      ensure_locked
      put sorted_filter_list() into gSortedFilterList
      put gSortedFilterList into tList
      put the cGap of group "Filters" into tGap
      put the cFilterRect of group "Filters" into tRect
      put item 1 of tRect into tLeft
      put item 2 of tRect into tVeryTop
      put tVeryTop into tTop
      repeat for each line i in tList
         set top of group i to tTop + tGap
         set left of group i to tLeft + tGap
         put tTop \
               + (the height of group i) \
               + tGap \
               into tTop
      end repeat
      -- set the rect of group "Filters" to tRect
      put total_height_of_filters() into tTotalHeight
      set the height of group "Filters" to tTotalHeight
      if tTotalHeight < the height of group "Filters" then
         set the height of group "Filters" to tTotalHeight
      end if
      if the height of group "Filters" \
            < the cMinHeight of group "Filters" then
         set the height of group "Filters" \
               to the cMinHeight of group "Filters"
      end if
      if the height of group "Filters" \
            > the cMaxHeight of group "Filters" then
         set the height of group "Filters" \
               to the cMaxHeight of group "Filters"
      end if
      set the top of group "Filters" to tVeryTop
      set the top of btn "new filter…" to the bottom of group "Filters" + 5
      set the top of btn "Add filter…" to the bottom of group "Filters" + 5
      set the top of btn "Action" to the bottom of btn "New filter…" + 5
      if the visible of gSearchGroup is true then
         set the top of gSearchGroup to the bottom of btn "Action" + 10
      end if
      send resize_background_graphic to group "Filters"
      set the lockLocation of group "Filters" to true
      put sorted_filter_list() into gSortedFilterList
      -- unlock screen
   end reposition_filters_neatly
   
   on update_filter_labels_etc
      put 0 into tLineCount
      repeat for each line tFilter in gSortedFilterList
         put tLineCount + 1 into tLineCount
         set the enabled of btn "search type" of group tFilter to true
         -- First Filter must be "Find":"
         if tLineCount = 1 then
            set the label of btn "search type" of group tFilter to "Find"
            set the enabled of btn "search type" of group tFilter to false
         else
            put "Add" & return & \
                  "Merge" & return & \
                  "Refine" \
                  into btn "Search type" of group tFilter
            set the label of btn "Search type" of group tFilter to \
                  the cSearchType of group tFilter
         end if
         -- group is "Merge"
         if the cSearchType of group tFilter is "Merge" then
            put line tLineCount - 1 of gSortedFilterList into tPreviousGroup
            get the cRGBcolor of group tPreviousGroup
            set the cRGBcolor of group tFilter to it
         end if
      end repeat
      -- put sorted_filter_list() into gSortedFilterList
   end update_filter_labels_etc
   
   function sorted_filter_list
      put empty into tFilterList
      repeat with i = 1 to the number of groups
         if the cGroupType of group i is not "Filter" then next repeat
         put (the short name of group i) & \
               comma & \
               (item 2 of the location of group i)\
               & return after tFilterList -- so we can sort by vertical loc
         sort lines of tFilterList numeric by item 2 of each
      end repeat
      put replacetext (tFilterlist, (",.+"),"") into tFilterList
      put empty into char -1 of tFilterlist
      return tFilterList
   end sorted_filter_list
   
   
   function _create_unique_filter_name
      put sorted_filter_list() into gSortedFilterList
      put gSortedFilterList into tFilters
      repeat with i = 1 to the number of lines of tFilters
         put line i of tFilters into tLine
         put the label of btn "Filter name" of group tLine into line i of tFilters
      end repeat
      put 1 into tFilterNumber
      repeat 100
         put "Filter" && tFilterNumber into tName
         if tName is in tFilters then
            put tFilterNumber + 1 into tFilterNumber
            next repeat
         else
            exit repeat
         end if
      end repeat
      return tName
   end _create_unique_filter_name
   
   
   function bottom_of_last_filter
      put empty into tFilterList
      put gSortedFilterList into tList
      repeat for each line i in tList
         put the bottom of group i & comma after tFilterList
      end repeat
      return max(tFilterList)
   end bottom_of_last_filter
   
   function total_height_of_filters
      put empty into tHeightList
      put the cGap of group "Filters" into tGap
      put gSortedFilterList into tList
      repeat for each line i in tList
         put the height of group i + tGap & \
               comma after tHeightList
      end repeat
      -- 1 pixel extra below to ensure no scrolling when
      -- filter group height < max height
      put sum(tHeightList) + tGap into tFilterHeight
      put the margins of group "Filters" into tMargins
      put tFilterHeight + (2 * tMargins) into tFilterHeight
      return tFilterHeight
   end total_height_of_filters
   
   on position_new_group
      set the rect of group "Filters" to \
            the cFilterRect of group "Filters"
      put the left of group "Filters" into tLeft
      put the top of group "Filters" into tTop
      copy group "Filter group" of stack "settings" to group "Filters"
      set the left of group "Filter group" to tLeft
      put the cGap of group "Filters" into tGap
      put bottom_of_last_filter() into tLastBottom
      if tLastBottom = 0 then -- no other filters
         put the top of group "Filters" into tLastBottom
      end if
      set the top of group "Filter group" to tLastBottom + tGap
   end position_new_group
   
   
   
   on show_advanced tFilterList
      repeat for each line i in tFilterList
         set the hilite of btn "Advanced" of Group i to true
         show group "Text before" of Group i
         show group "Text after" of Group i
         put the long ID of group i into tGroup
         resize_backdrop(i)
      end repeat
   end show_advanced tFilterList
   
   on hide_advanced tFilterList
      repeat for each line i in tFilterList
         set the hilite of btn "Advanced" of Group i to false
         hide group "Text before" of Group i
         hide group "Text after" of Group i
         resize_backdrop(i)
      end repeat
   end hide_advanced tFilterList
   
   
   on resize_backdrop pFilter
      if the visible of group "Filter details" of group pFilter is true then
         if the visible of group "Text before" of group pFilter is true then
            put the cAdvancedHeight of btn "backdrop" of group pFilter into tHeight
         else
            put the cStandardHeight of btn "backdrop" of group pFilter into tHeight
         end if
      else
         put the cCompactHeight of btn "backdrop" of group pFilter into tHeight
      end if
      set the height of btn "backdrop" of group pFilter to tHeight
      set the top of btn "backdrop" of group pFilter \
            to the top of btn "hand" of group pFilter
   end resize_backdrop
   
   --
   -- See here for lighter/darker coloring:
   -- http://forums.livecode.com/viewtopic.php?t=11100
   --
   function make_lighter pRGB pValue
      put pRGB into tRGB
      put empty into tLighter
      put fld "Lighter" of stack "settings" into pValue
      put pValue/100 into pValue
      repeat with i = 1 to the number of items of tRGB
         put item i of tRGB into tColorItem
         put round ((1 - pValue) * tColorItem + ((pValue) * 255)) into item i of tLighter
      end repeat
      return tLighter
   end make_lighter
   
   function make_darker pRGB pValue
      put pRGB into tRGB
      put empty into tDarker
      put fld "Darker" of stack "settings" into pValue
      put pValue/100 into pValue
      repeat with i = 1 to the number of items of tRGB
         put item i of tRGB into tColorItem
         put round (((1 - pValue) * tColorItem)) into item i of tDarker
      end repeat
      return tDarker
   end make_darker
   
   on show_filter_details tList
      lock screen
      put the vscroll of group "Filters" into tScroll
      repeat for each line i in tList
         set the hilited of btn "show_hide filter" of \
               group i to true
         show group "Filter details" of group i
      end repeat
      reposition_filters_neatly
      set the vscroll of group "filters" to tScroll
      
      -- put the long ID of group i into tGroup
      resize_backdrop(i)
      -- unlock screen
   end show_filter_details
   
   on hide_filter_details tList
      lock screen
      put the vscroll of group "Filters" into tScroll
      repeat for each line i in tList
         set the hilited of btn "show_hide filter" of \
               group i to false
         hide group "Filter details" of group i
         resize_backdrop(i)
      end repeat
      reposition_filters_neatly
      set the vscroll of group "filters" to tScroll
      -- unlock screen
   end hide_filter_details tList
   
   on save_scroll
      set the cScroll of the target to the vscroll of the target
   end save_scroll
   
   
   on reset_scroll
      ensure_locked
      set the vscroll of fld "Main text" to the cScroll of fld "Main text"
      -- unlock screen
   end reset_scroll
   
   on create_new_filter pName, pRGBColor
      ensure_locked
      -- pName, pRGBColor are optional
      if pName is empty then
         put _create_unique_filter_name() into tName
      else
         put pName into tName
      end if
      position_new_group tGap
      set the name of group "Filter group" to tName
      set the label of btn "Filter name" of group tName to tName
      hide_advanced tName
      put sorted_filter_list() into gSortedFilterList
      if pRGBColor is empty then
         put select_next_color() into pRGBColor
      end if
      set the cRGBColor of group tName to pRGBColor
      set the cHexColor of group tName to convert_to_hex(pRGBColor)
      apply_filter_tags -- to ensure tags are present at start of do_find
      update_filter_color tName
      send resize_background_graphic to group "Filters"
      update_filter_labels_etc
      reposition_filters_neatly
      reset_scroll
      --
      put line -1 of gSortedFilterList into tFilter -- filter just created
      if the number of lines of gSortedFilterList is 1 then
         set the label of btn "Search type" of group tFilter to "Find"
         set the cSearchType of group tFilter to "Find"
      else
         set the label of btn "Search type" of group tFilter to "Add"
         set the cSearchType of group tFilter to "Add"
      end if
      set the hilite of btn "regexp" of group tFilter to true
      set the hilite of btn "ignore case" of group tFilter to true
      set the hilite of btn "Multiline" of group tFilter to true
      set the disabled of btn "View option" to false
      unlock screen
      do_live_search
   end create_new_filter
   
   function select_next_color
      put list_of_colors() into tColorList
      if the number of lines of gSortedFilterList is 1 then
         return line 1 of tColorList
      end if
      put line -2 of gSortedFilterList into tLastFilter
      put the cRGBColor of group tLastFilter into tLastRGBColor
      put lineoffset(tLastRGBColor, tColorList) into tWhichLine
      if tWhichLine = 9 then
         return line 1 of tColorList
      else
         put tWhichLine +1 into tWhichLine
         return line tWhichLine of tColorList
      end if
      -- put empty into tExistingColors
      -- put gSortedFilterList into tList
      -- repeat for each line i in tList
      -- put the cRGBcolor of group i & return after tExistingColors
      -- end repeat
      -- put empty into the last char of tList
      -- --
      -- put empty into tColors
      -- repeat with i = 1 to the number of fields of stack "Colors"
      -- if the cType of fld i of stack "Colors" is "Color" then
      -- put the backgroundcolor of fld i \
      -- of stack "Colors" & return after tColors
      -- end if
      -- end repeat
      -- put empty into the last char of tColors
      -- --
      -- put the number of lines of tColors into tNumberOfColors
      -- put list_of_colors() into tColorList
      -- repeat 20
      -- put random(tNumberOfColors) into tWhichLine
      -- put line tWhichLine of tColors into tNewColor
      -- if tNewColor is in tExistingColors then
      -- next repeat
      -- else
      -- exit repeat
      -- end if
      -- end repeat
      -- return tNewColor
   end select_next_color
   
   function list_of_colors
      put empty into tColorList
      repeat with i = 1 to 9
         put the backgroundcolor of fld i of stack "colors" \
               & "•" & the short name of fld i of stack "colors" \
               into tColor
         -- put convert_to_hex(tColor) & return after tColorList
         put tColor & return after tColorList
      end repeat
      set the itemDelimiter to "•"
      sort lines of tColorList by item 2 of each
      put replacetext(tColorList,"•.+", "") into tColorList
      Put empty into the last char of tColorList
      return tColorList
   end list_of_colors
   
   on update_filter_color pFilter
      put pFilter into tFilter
      put fld "Lighter" of stack "settings" into tLighterAmount
      put the cRGBcolor of group tFilter into tColor
      put make_lighter(tColor, tLighterAmount/100) into tLighter
      set the bordercolor of group tFilter to tLighter
      set the backgroundcolor of group tFilter to tLighter
      put fld "Darker" of stack "settings" into tDarkerAmount
      put make_darker(tColor, tDarkerAmount/100) into tDarker
      set the backgroundcolor of fld "Count" of group tFilter to tColor
      set the backgroundcolor of fld "Milliseconds" of group tFilter to tLighter
      set the textcolor of fld "Milliseconds" of group tFilter to tDarker
      set the backgroundcolor of btn "Before" of group tFilter to tColor
      set the backgroundcolor of btn "After" of group tFilter to tColor
      set the backgroundcolor of btn "Filter name" of group tFilter to tColor
      set the textcolor of btn "Regexp" of group tFilter to tDarker
      set the textcolor of btn "Ignore case" of group tFilter to tDarker
      set the textcolor of btn "Multiline" of group tFilter to tDarker
      set the textcolor of btn "Whole word" of group tFilter to tDarker
      set the textcolor of btn "Hand" of group tFilter to tDarker
      set the textcolor of btn "Save" of group tFilter to tDarker
      set the textcolor of btn "Edit" of group tFilter to tDarker
   end update_filter_color
   
   on update_text
      ensure_locked
      -- put the short name of fld "search" of \
      -- group gActiveFilter into gActiveSearchField
      -- -- reorder
      -- set the label of btn "Search type" of group gActiveFilter to \
      -- the cSearchType of group gActiveFilter
      do_find
      set_text_scroll
      -- unlock screen
   end update_text
   
   
   -- ====================== Database handlers ====================
   
   
   on refresh
      read_filters_from_database
      write_to_database
      get_remote_prefs
   end refresh
   
   on read_filters_from_database
      -- Use local data to update menu
      put empty into btn "Add filter…"
      if gWholeTable is empty then
         -- nothing in database
         exit read_filters_from_database
      end if
      repeat with i = 1 to the number of elements of filter_name
         if filter_name[i] is not empty then
            put filter_name[i] & return after btn "Add filter…"
         end if
      end repeat
      put empty into char -1 of btn "Add filter…" -- remove last return
      -- now update regex mode buttons like "ignore case"
      -- update_search_mode_btns
   end read_filters_from_database
   
   on update_search_mode_btns
      put the selectedText of btn "Add filter…" into tCurrentName
      put text_before[tCurrentName] into fld "Text before"
      put search_string[tCurrentName] into fld "search"
      put text_after[tCurrentName] into fld "Text after"
      put replace_string[tCurrentName] into fld "replace"
      
      repeat with i = 1 to the number of btns of group "regex mode"
         put the short name of btn i of group "regex mode" \
               into current_mode
         put "set the hilite of btn" && \
               quote & current_mode & quote && \
               "to" && \
               current_mode & \
               "[tCurrentName]" \
               into tTodo
         do tTodo
      end repeat
   end update_search_mode_btns
   
   on update_active_search
      put the selectedText of btn "Add filter…" into tNewFiler
      put fld "search" into the_search
      if the hilite of btn "Regexp" is false then
         put convert_field_to_regexp(tNewFiler, the_search) into the_search
      end if
      -- e.g. put "\$.+?\$" into search_string["All math"]:
      put the_search into search_string[tNewFiler]
      put fld "replace" into replace_string[tNewFiler]
      put fld "Text before" into text_before[tNewFiler]
      put fld "Text after" into text_after[tNewFiler]
      put the number of btns of group "regex mode" \
            into tNo_of_modes
      repeat with i = 1 to tNo_of_modes
         put the short name of btn i of group "regex mode" \
               into tMode
         do "put the hilite of btn" && \
               quote & tMode & quote && \
               "into" && \
               tMode & \
               "[" & quote & tNewFiler & quote & "]"
      end repeat
      write_to_database
   end update_active_search
   
   on connect   
      if gConnectionID is a number then
         -- we are already connected to the database
         -- exit connect
      end if 
      -- set up the connection parameters
      put "dedi1148.your-server.de" into DatabaseAddress
      put "kavehn_db1" into DatabaseName
      put "kavehn_1" into DatabaseUser
      put "ZK7tnZaMav1cL3pX" into DatabasePassword
          
      -- connect to the database
      put revOpenDatabase( \
            "MySQL", \
            DatabaseAddress, \
            DatabaseName, \
            DatabaseUser, \
            DatabasePassword \
            ) \
            into the_result
          
      -- check if it worked and display an error message if it didn't
      -- & set the connection ID global
      if the_result is a number then
         put the_result into gConnectionID
         --        answer info "Connected to the database." & cr & "Connection ID = " & ggConnectionID
      else
         put empty into gConnectionID
         answer error "Unable to connect to the database:" & cr & the_result
      end if
   end connect
   
   function do_sql SQL
      put revDataFromQuery(tab, return, gConnectionID, SQL) into tData
      -- check the result and display the data or an error message
      if item 1 of the_data = "revdberr" then
         -- answer error "There was a problem querying the database:" & cr & the_data
         -- need to check why this gives error on writing out data. Temporarily commented
      else
         return tData
      end if
   end do_sql
   
   on delete_database_table
      if gConnectionID is not a number then
         connect
      end if
      put "DELETE FROM" && "RVClean" into SQL
      revExecuteSQL gConnectionID, SQL
      if the result is not a number then
         answer error "There was a problem clearing the database" & cr & the result
      end if
   end delete_database_table
   
   function filter_exists tFilter
      connect
      put "SELECT * FROM" && \
            gTableName && \
            "WHERE filter_name = '" & \
            tFilter & \
            "'" \
            into SQL
      get do_sql(SQL)
      if it is empty then
         return false
      else
         return true
      end if
   end filter_exists
   
   function pattern_exists pPattern
      connect
      put "SELECT * FROM" && \
            gPatternTableName && \
            "WHERE pattern_name = '" & \
            pPattern & \
            "'" \
            into SQL
      get do_sql(SQL)
      if it is empty then
         return false
      else
         return true
      end if
   end pattern_exists
   
   on write_filter_to_database tFilterName
      put fld "search" of group tFilterName into tSearch
      put fld "Text before" of group tFilterName into tTextBefore
      put fld "Text after" of group tFilterName into tTextAfter
      -- need to escape some fields for SQL
      put escape_for_mySQL(tFilterName) \
            into tFilterName
      put escape_for_mySQL(tSearch) \
            into tSearch
      put escape_for_mySQL(tTextBefore) \
            into tTextBefore
      put escape_for_mySQL(tTextAfter) \
            into tTextAfter
      --
      get the label of btn "Text before option" of group tFilterName
      if it is "=" then
         put "true" into tOption
      else if it is "≠" then
         put "false" into tOption
      end if
      put tOption into tBeforeOption
      --
      get the label of btn "Text after option" group tFilterName
      if it is "=" then
         put "true" into tOption
      else if it is "≠" then
         put "false" into tOption
      end if
      put tOption into tAfterOption
      --
      get hilite of btn "Ignore case" of group tFilterName
      if it is true then
         put "true" into tIgnoreCase
      else
         put "false" into tIgnoreCase
      end if
      --
      get hilite of btn "Multiline" of group tFilterName
      if it is true then
         put "true" into tMultiline
      else
         put "false" into tMultiline
      end if
      --
      get hilite of btn "Whole word" of group tFilterName
      if it is true then
         put "true" into tWholeWord
      else
         put "false" into tWholeWord
      end if
      --
      put the cFilterID of group tFilterName into tFilterID
      put "INSERT INTO" && \
            gTableName && \
            "(" & \
            "filter_name" & "," && \
            "search_string" & "," && \
            "text_before" & "," && \
            "text_before_option" & "," && \
            "text_after" & "," && \
            "text_after_option" & "," && \ -- "filter_category" & "," && \
            "ignore_case" & "," && \
            "Multiline" & "," && \
            "whole_word" & \
            ")" && return &\
            "VALUES (" & \
            "'" & tFilterName & "'" &", " & \
            "'" & tSearch & "'" &", " & \
            "'" & tTextBefore & "'" &", " & \
            "'" & tBeforeOption & "'" &", " & \
            "'" & tTextAfter & "'" &", " & \
            "'" & tAfterOption & "'" &", " & \ -- "'" & filter_category[tFilterName] & "'" &", " & \
            "'" & tIgnoreCase & "'" &", " & \
            "'" & tMultiline & "'" &", " & \
            "'" & tWholeWord & "'" & \
            ");" \
            into SQL
      get do_sql(SQL)
      
      -- delete_empty_rows
   end write_filter_to_database
   
   function escape_for_mySQL pText
      replace "\" with "\\" in pText
      replace "'" with "\'" in pText
      return pText
   end escape_for_mySQL
   
   on delete_empty_rows
      put "DELETE FROM" && gTableName && "WHERE search_name =''" into SQL
      get do_sql(SQL)
   end delete_empty_rows
   
   on get_remote_prefs
      -- Easy way to check for internet connection
      put url "http://www.google.com" into tURL
      if tURL is empty then
         answer "Could not update preferences. Using local prefs"
         exit get_remote_prefs
      end if
      put "RVClean" into gTableName
      put "RVClean_ref_patterns" into gPatternTableName
      put "RVClean_bug_reports" into gBugTableName
      connect
      -- put "SELECT * FROM" && gTableName into SQL
      -- put do_sql(SQL) into gWholeTable -- entire table
      
      
      -- put "SHOW FIELDS FROM" && gTableName into SQL -- the column names
      -- put do_sql(SQL) into gColumns
      
      put empty into search_name
      
      -- clean_up_columns
      -- split_table
      put mk_setprefs(gWholeTable) into tResult
      if tResult <> empty then
         answer "There was an error when saving the preferences!" \
               & CR & tResult
      end if
   end get_remote_prefs
   
   on clean_up_columns
      repeat with i = 1 to the number of lines of gColumns
         -- keep just word 1, e.g. "search_name	varchar(100)	YES" -> "search_name"
         put word 1 of line i of gColumns into line i of gColumns
      end repeat
   end clean_up_columns
   
   --
   /*
   this handler combines "gColumns" and "gWholeTable" to produce arrays, e.g.
   search_string[], replace_string[]
   so we can refer to search_string["The search name"] and get the grep string
   e.g. search_name[1] = "all math" etc
   */
   --
   
   
   
   --   on add_filter_from_database pFilter
   --      put "SELECT filter_name, search_string, text_before, text_before_option, text_after," && \
   --            "text_after_option, filter_category, ignore_case, Multiline, whole_word, filter_ID" && \
   --            "FROM" && \
   --            gTableName && \
   --            "WHERE filter_name = '" & pFilter & "'" \
   --            into SQL
   --      put do_sql(SQL) into tNewData
   --      set the itemDelimiter to tab
   --      put item 1 of tNewData into tFilterName
   --      put item 2 of tNewData into tSearchString
   --      put item 3 of tNewData into tTextBefore
   --      put item 4 of tNewData into tTextBeforeOption
   --      put item 5 of tNewData into tTextAfter
   --      put item 6 of tNewData into tTextAfterOption
   --      put item 7 of tNewData into tFilterCategory
   --      put item 8 of tNewData into tIgnoreCase
   --      put item 9 of tNewData into tMultiline
   --      put item 10 of tNewData into tWholeWord
   --      put item 11 of tNewData into tFilterID
   
   --      put sorted_filter_list() into gSortedFilterList
   --      create_new_filter pFilter
   --      put pFilter into tFilter
   --      set the cFilterID of group tFilter to tFilterID
   --      put tSearchString into fld "Search" of group tFilter
   --      put tTextBefore into fld "Text before" of group tFilter
   --      put tTextAfter into fld "Text after" of group tFilter
   --      if tIgnoreCase is "true" then
   --         set the hilite of btn "Ignore case" of group tFilter to true
   --      else
   --         set the hilite of btn "Ignore case" of group tFilter to false
   --      end if
   --      if tMultiline is "true" then
   --         set the hilite of btn "Multiline" of group tFilter to true
   --      else
   --         set the hilite of btn "Multiline" of group tFilter to false
   --      end if
   --      if tWholeWord is "true" then
   --         set the hilite of btn "Whole word" of group tFilter to true
   --      else
   --         set the hilite of btn "Whole word" of group tFilter to false
   --      end if
   --      if the number of lines of gSortedFilterList is 1 then
   --         set the label of btn "Search type" of group tFilter to "Find"
   --         set the cSearchType of group tFilter to "Find"
   --      else
   --         set the label of btn "Search type" of group tFilter to "Add"
   --         set the cSearchType of group tFilter to "Add"
   --      end if
   --      if tBeforeOption is "is" then
   --         set the label of btn "Text before option" of group tFilter to "="
   --      else if tBeforeOption is "is not" then
   --         set the label of btn "Text before option" of group tFilter to "≠"
   --      end if
   --      if tAfterOption is "is" then
   --         set the label of btn "Text after option" of group tFilter to "="
   --      else if tAfterOption is "is not" then
   --         set the label of btn "Text after option" of group tFilter to "≠"
   --      end if
   --      set the hilite of btn "Regexp" of group tFilter to true
   --   end add_filter_from_database
   
   function TimeTag_to_begin_tag tTime
      return "•A" & tTime & "B•"
   end TimeTag_to_begin_tag
   
   function TimeTag_to_mid_tag tTime
      return "•B" & tTime & "C•"
   end TimeTag_to_mid_tag
   
   function TimeTag_to_end_tag tTime
      return "•A" & tTime & "C•"
   end TimeTag_to_end_tag
   
   on deactivate_all_filter_controls
      set the disabled of group "filters" to true
      set the disabled of btn "New filter…" to true
      set the disabled of btn "Add filter…" to true
   end deactivate_all_filter_controls
   
   on activate_all_filter_controls
      set the disabled of group "filters" to false
      set the disabled of btn "New filter…" to false
      set the disabled of btn "Add filter…" to false
   end activate_all_filter_controls
   
   on save_regex_for_fields
      repeat for each line L in gSortedFilterList
         set the cFullRegex of group L to construct_full_regex(L)
         set the cBasicRegex of group L to construct_basic_regex(L)
      end repeat
   end save_regex_for_fields
   
   on update_original_text
      set the cOriginalText of fld "Main text" to fld "Main text"
   end update_original_text
   
   
   function quick_count \
         pText, \
         pString
      -- A fast way of finding the number of occurences in fld "Main text"
      -- e.g. so we can avoid a long text coloring process
      -- see http://bit.ly/2SgCsXz
      put the ticks into tUniqueString
      put replacetext( \
            pText, \
            pString, \
            return & tUniqueString & return \
            ) \
            into tNumber
      filter tNumber with tUniqueString
      return the number of lines of tNumber
   end quick_count
   
   on update_filter_menu
      set the text of btn "Add filter" to filters_in_database()
   end update_filter_menu
   
   function filters_in_database
      put "SELECT filter_name FROM" && gTableName into SQL
      connect
      return do_sql(SQL)
   end filters_in_database
   
   
   on update_marker_menu
      put fld "Environments" of stack "settings" into tEnvironments
      put empty into tMenuList
      repeat for each line L in tEnvironments
         put "Begin" && L & return after tMenuList
         put "End" && L & return after tMenuList
      end repeat
      put empty into char -1 of tMenuList
      set the text of btn "Set marker" to tMenuList
   end update_marker_menu
   
   on update_zone_menu
      put fld "Environments" of stack "settings" into \
            btn "Select zone"
   end update_zone_menu
   
   function begin_marker pChoice
      put pChoice into tEnvironment
      put replacetext(tEnvironment, "(^ )", "") into tEnvironment -- remove space at start
      put fld "Pre-marker" of stack "Settings" into tPreMarker
      put fld "Post-marker" of stack "Settings" into tPostMarker
      put "Begin" && tEnvironment into tMarker
      put tPreMarker && \
            tMarker && \
            tPostMarker \
            into tMarker
      return tMarker
   end begin_marker
   
   function end_marker pChoice
      put pChoice into tEnvironment
      put replacetext(tEnvironment, "(^ )", "") into tEnvironment -- remove space at start
      put fld "Pre-marker" of stack "Settings" into tPreMarker
      put fld "Post-marker" of stack "Settings" into tPostMarker
      put "End" && tEnvironment into tMarker
      put tPreMarker && \
            tMarker && \
            tPostMarker \
            into tMarker
      return tMarker
   end end_marker
   
   function search_string_for_zone pZone
      put "(" & \
            "(?is)" & \
            begin_marker(pZone) & \
            ".+" & \
            end_marker(pZone) & \
            ")" \
            into tSearchString
      return tSearchString
   end search_string_for_zone
   
   function markers_exist pZone
      put begin_marker(pZone) into tBeginString
      put end_marker(pZone) into tEndString
      if matchChunk(fld "Main text",tBeginString) is true \
            and matchChunk(fld "Main text",tEndString) is true
      then
         return true
      else
         return false
      end if
   end markers_exist
   
   function zones_marked
      put fld "Environments" of stack "settings" into tZones
      put empty into tZonesMarked
      repeat for each line L in tZones
         if markers_exist(L) is true then
            put L & return after tZonesMarked
         end if
         put empty into char -1 of tZonesMarked
      end repeat
      return tZonesMarked
   end zones_marked
   
   
   function search_string_for_ref_with_ID pID
      put "(?is)(\\bibitem[^•]*?{(" & \
            pID & \
            ")}[^•]+)" \
            into tSearch
      return tSearch
   end search_string_for_ref_with_ID
   
function convert_diacritics_to_tex pText
   --   put sDiacritics into tSpecialChars
   repeat with i = 1 to the number of lines of sDiacritics
      set the itemDelimiter to tab
      put item 1 of line i of sDiacritics into tOriginal
      -- put "(" & original_char & ")" into original_char
      put item 4 of line i of sDiacritics & "{}" into tReplacement
      put replacetext( \
            pText, \
            tOriginal, \
            tReplacement \
            ) \
            into pText
   end repeat
   put _convert_single_char_diacritics_to_tex(pText) into pText
   return pText
end convert_diacritics_to_tex
   
   function convert_tex_to_diacritics pText
      -- e.g. "\'a" > "\' a" to help with regex
      put _insert_space_after_diacritic_accent(pText) into pText
      --   answer sAccentsA["á"]["Root"]
      set the itemdelimiter to tab
      repeat for each line L in sDiacritics
         -- e.g. \l or \ae
         if item 2 of L is empty \
               AND item 3 of L is empty then
            put item 4 of L into tTeXVersion
            put item 1 of L into tAccentedLetter
            put force_to_regexp(tTeXVersion) into tTeXVersion
            put "((?sx)" & tTeXVersion & "(?![A-Za-z])\s*" & ")" into tSearch
            put replacetext( \
                  pText, \
                  tSearch, \
                  tAccentedLetter \
                  ) \
                  into pText
         else
            put item 2 of L into tAccent
            put force_to_regexp(tAccent) into tAccent -- e.g. \^ > \\\^
            put item 3 of L into tLetter
            put force_to_regexp(tLetter) into tLetter -- e.g. \i > \\i
            put item 1 of L into tAccentedLetter
            --         ensure e.g. \v is not part of macro, so next char not letter:
            put "(" & tAccent & "\s*{" & tLetter & "}" & ")" into tSearch -- e.g. \' {e}
            put replacetext( \
                  pText, \
                  tSearch, \
                  tAccentedLetter \
                  ) \
                  into pText
            put "({" & tAccent & "\s+" & tLetter & "})" into tSearch -- e.g. {\' e}
            put replacetext( \
                  pText, \
                  tSearch, \
                  tAccentedLetter \
                  ) \
                  into pText
            put "(" & tAccent & "\s+" & tLetter & ")" into tSearch -- e.g. \' e
            put replacetext( \
                  pText, \
                  tSearch, \
                  tAccentedLetter \
                  ) \
                  into pText
         end if
      end repeat
      --   put _convert_single_char_tex_to_diacritics(pText) into pText
      -- e.g. {Ł} > Ł :
      get sunnYreplace(pText, "{([À-ž]+)}", "\1", pText)
      -- remove empty braces after diacritics: Ł{} > Ł
      put replacetext(ptext, "(?<=[À-ž])({})", "") into pText
      return pText
   end convert_tex_to_diacritics
   
   function _insert_space_after_diacritic_accent pText
      -- e.g. "\'a" > "\' a" to help with regex
      -- so \' \" \r all need space after (avoids converting e.g. \raggedright)
      set the itemdelimiter to tab
      repeat for each line L in sDiacritics
         put item 2 of L into tAccent
         put char 2 of tAccent into tChar
         if matchchunk(tChar, "([A-Za-z])") is true then next repeat
         put force_to_regexp(tAccent) into tAccentRegex
         -- first two chars are \\ then two if forced to regexp:
         put char 3 to -1 of tAccentRegex into tChars
         put "(" & tAccentRegex & "(?!\s))" into tSearch
         put replacetext(pText, tSearch, tAccent & space) into pText
         -- special case: \" :
         put replacetext(pText, "(\\" & quote & "(?!\s))", "\" & quote & space) into pText
      end repeat
      return pText
   end _insert_space_after_diacritic_accent
   
   
   function _convert_single_char_diacritics_to_tex pText
      put replacetext(pText, "æ", "\ae{}") into pText
      put replacetext(pText, "ø", "\o{}") into pText
      return pText
   end _convert_single_char_diacritics_to_tex
   
   
   on style_extracted_refs
      put the long name of fld "Reference list" of stack "Reference manager" into tField
      put the text of tField into tRefs
      set the itemdelimiter to tab
      set the text of tField to tRefs -- remove styles
      repeat with i = 1 to the number of lines of tRefs
         set the textstyle of item 1 of line i of tField to "italic"
         set the textcolor of item 1 of line i of tField to Brown
      end repeat
   end style_extracted_refs
   
   
   function isChunkItem tChar
      return matchText( \
            char tChar of fld "Main text", \
            gSelectionChars \
            )
   end isChunkItem
   
   function text_is_selected
      answer the selectedchunk of fld "Main text"
      
      put the selectedchunk of fld "Main text" into tChunk
      if word 4 of tChunk < word 2 of tText then
         return false
      else
         return true
      end if
   end text_is_selected
   
   on delete_filter tFilterName
      Delete tFilterName
      put sorted_filter_list() into gSortedFilterList
      reposition_filters_neatly
   end delete_filter
   
   
   
   -------------------- old escape key script -------------
   --   on rawkeyup theKey
   --      answer the target
   --      if theKey is 65307 then -- escape
   --         if the target is not in stack "RVClean" then
   --            exit rawkeyup
   --         end if
   --         if the visible of grp "Search and replace" is true then
   --            pass rawKeyUp
   --         end if
   --         ensure_locked
   --         put the vscroll of fld "Main text" into tScroll
   --         send swap_mode to fld "Main text"
   --         -- put fld "Main text" into fld "Main text" -- remove styles
   --         set the vscroll of fld "Main text" to tScroll
   --      end if
   --      pass rawkeyup
   --      wait 1 tick -- to ensure no screen flicker
   --      -- unlock screen
   --   end rawkeyup
   
   function extract_key pFieldName, pChar
      ensure_locked
      -- get the Key of bibitem cursor is in
      put extract_para(pFieldName, pChar) into tBib
      put empty into tKey
      get matchtext( \
            tBib, \
            "(?s)\\bibitem\s*(?:\[.+?\])?({.+?})", \
            tKey)
      return tKey
   end extract_key
   
   
   
   function extract_para pField, pChar
      -- extract paragraph where cursor is in
      put char 1 to pChar of the text of fld pField into tTopPart
      put char pChar + 1 to -1 of the text of fld pField into tBottomPart
      put replacetext( \
            tTopPart, \
            "(?s)(.+\n\n)", \
            "" \
            ) \
            into tTopPart
      put replacetext( \
            tBottomPart, \
            "(?s)(\n\n.+)", \
            "") \
            into tBottomPart
      put tTopPart & tBottomPart into tRef
      return tRef
   end extract_para
   
   function brackets_around tText
      return "(" & tText & ")"
   end brackets_around
   
   function line_of_key pField, pKey
      put force_to_regexp(pKey) into pKey
      -- in case we have e.g. {33} which is a special regex construct
      put "(?s)(.+" & pKey & ")" into tSearch
      put empty into tStart
      put empty into tEnd
      get matchChunk(fld pField, tSearch, tStart, tEnd)
      put char 1 to tEnd + 1 of fld pField into tString
      put quick_count(tString, "(\n)") into tLine
      return tLine
   end line_of_key
   
   
   on _color_focused_ref pField, pKey
      if the lineOffset("\bibitem",  fld pField) = 0 then
         exit _color_focused_ref
      end if
      put the backgroundcolor of fld "bibitem bg" of stack settings \
            into tBGcolor
      put line_of_key(pField, pKey) + 1 into tLine
      ensure_locked
      set the backgroundcolor of line 1 to -1 of fld pField to empty
      if pField is "Unstructured" then
         set the textstyle of line 1 to -1 of fld pField to empty
      end if
      
      repeat until lineOffset("\bibitem", line tLine of fld pField)  > 0
         -- first line of bibitem is on two lines
         put tLine - 1 into tLine
      end repeat
      put tLine - 1 into tCount
      repeat forever
         put tCount+1 into tCount
         if line tCount of fld pField is empty \
               OR tCount =  the number of lines of fld pField then
            exit repeat
         end if
         set the textstyle of line tCount of fld pField to bold
         set the backgroundcolor of line tCount of fld pField to tBGcolor
      end repeat
   end _color_focused_ref
   
   
   on correct_scroll_to_view_item pFld, pKey
      put force_to_regexp(pKey) into pKey
      put empty into tStart
      put empty into tEnd
      put "(?s)(.+" & pKey & ")" into tSearch
      -- from top of file to tText:
      get matchchunk(fld pFld, tSearch, tStart, tEnd)
      -- go to bottom of field:
      select char -1 of fld pFld
      -- go back up to near tKey:
      select char tEnd to tEnd +1 of fld pFld
      -- final correction to bring into view:
      put the height of fld pFld into tHeight
      set the vscroll of fld pFld to the vscroll of fld pFld - tHeight/2   + 30
   end correct_scroll_to_view_item
   
   function correct_date
      put the system date into tDate -- e.g. 02/04/2019
      --   set the itemdelimiter to "/"
      --   put item 3 of tDate & "-" & \
      --         item 2 of tDate & "-" & \
      --         item 1 of tDate \
      --         into tDate
      return tDate
   end correct_date
   
   function general_clean_up pText
      put the number of lines of btn "Table of patterns" \
            of stack "General clean-up" into tPatterns
      repeat with i = 1 to tPatterns
         put line i of btn "Table of patterns" \
               of stack "General clean-up" into tTableName
         put tTableName && "headings" into tTableHeadings
         switch tTableName
            case "replace pattern"
               put HTML_start(1, tTableHeadings) into pSearchHTMLstart
               put HTML_end(1, tTableHeadings) into pSearchHTMLend
               put HTML_start(3, tTableHeadings) into pReplaceHTMLstart
               put HTML_end(3, tTableHeadings) into pReplaceHTMLend
               --
               put the HTMLText of fld tTableName \
                     of stack "General clean-up" into tHTML
               replace "<p>" with "" in tHTML
               replace "</p>" with "" in tHTML
               set the itemDelimiter to "&#9;"
               --
               repeat with j = 1 to the number of lines of tHTML
                  put item 1 of line j of tHTML into tChunk
                  put item 2 of line j of tHTML into tSearch
                  put item 3 of line j of tHTML into tReplace
                  put search_replace ( \
                        pText,  \
                        tChunk,  \
                        tSearch,  \
                        tReplace, \
                        pSearchHTMLstart, \
                        pSearchHTMLend,  \
                        pReplaceHTMLstart,  \
                        pReplaceHTMLend \
                        ) \
                        into pText
               end repeat
               break
               --         case "Put nonbreaking space after"
               --            --
               --            repeat with j = 1 to the number of lines of tLines
               --               put item 1 of line j of tLines into tTextToTie
               --               put non_breaking_space_after( \
               --                     pText,  \
               --                     tTextToTie, \
               --                     pSearchHTMLstart, \
               --                     pSearchHTMLend, \
               --                     pReplaceHTMLstart,  \
               --                     pReplaceHTMLend \
               --                     ) into pText
               --            end repeat
               --            break
               --         case "Put nonbreaking space before"
               --            put the text of fld tTableName \
               --                  of stack "General clean-up" into tLines
               --            repeat with j = 1 to the number of lines of tLines
               --               set the itemdelimiter to tab
               --               put item 1 of line j of tLines into tTextToTie
               --               put non_breaking_space_before(pText, tTextToTie) into pText
               --            end repeat
               --            break
               --         case "Put nonbreaking space before and after"
               --            put the text of fld tTableName \
               --                  of stack "General clean-up" into tLines
               --            repeat with j = 1 to the number of lines of tLines
               --               set the itemdelimiter to tab
               --               put item 1 of line j of tLines into tTextToTie
               --               put non_breaking_space_before(pText, tTextToTie) into pText
               --               put non_breaking_space_after(pText, tTextToTie) into pText
               --            end repeat
               --            break
         end switch
      end repeat
      return pText
   end general_clean_up
   
   function non_breaking_space_after \
         pText,  \
         pTextToTie, \
         pSearchHTMLstart,  \
         pSearchHTMLend,  \
         pReplaceHTMLstart,  \
         pReplaceHTMLend
      put pTextToTie & "\s+" into tChunk
      put "~" into tReplace
      put search_replace(pText, tChunk, "\s+", tReplace) into pText
      return pText
   end non_breaking_space_after
   
   function non_breaking_space_before pText, pTextToTie, \
         pSearchHTMLstart, pSearchHTMLend, pReplaceHTMLstart, pReplaceHTMLend
      put "\s+" & pTextToTie into tChunk
      put "~" into tReplace
      put search_replace(pText, tChunk, "\s+", tReplace) into pText
      return pText
   end non_breaking_space_before
   
   function search_replace \
         pText \
         pChunk,  \
         pSearch,  \
         pReplace, \
         pSearchHTMLstart,  \
         pSearchHTMLend,  \
         pReplaceHTMLstart,  \
         pReplaceHTMLend
      put empty into tStart
      put empty into tEnd
      put "(" &pChunk & ")" into pChunk
      put empty into tReturnedText
      repeat forever
         if not matchchunk(pText, pChunk, tStart, tEnd) then
            exit repeat
         end if
         put char 1 to tEnd of pText into tShaved
         put empty into char 1 to tEnd of pText
         put char tStart to -1 of tShaved into tFound
         put replace_in_chunk(tFound,  \
               pSearch,  \
               pReplace, \
               pSearchHTMLstart, \
               pSearchHTMLend,  \
               pReplaceHTMLstart,  \
               pReplaceHTMLend \
               ) into tReplacement
         put tReplacement into char tStart to -1 of tShaved
         put tShaved after tReturnedText
      end repeat
      put pText after tReturnedText
      return tReturnedText
   end search_replace
   
   function replace_in_chunk \
         pChunk \
         pSearch,  \
         pReplace, \
         pSearchHTMLstart,  \
         pSearchHTMLend,  \
         pReplaceHTMLstart,  \
         pReplaceHTMLend
      put empty into tStart
      put empty into tEnd
      put "(" & pSearch & ")" into pSearch
      if matchchunk(pChunk, pSearch, tStart, tEnd) then
         put pReplaceHTMLstart & \
               pReplace & \
               pReplaceHTMLend \
               into char tStart to tEnd of pChunk
      end if
      return pSearchHTMLstart & \
            pChunk & \
            pSearchHTMLend
   end replace_in_chunk
   
   function HTML_start pColumn, pTable
      set the itemDelimiter to tab
      get the textColor of item pColumn of fld pTable of stack "General clean-up"
      put it into tTextColor
      put convert_to_hex(tTextColor) into tTextColor
      --
      get the backgroundColor of item pColumn of fld pTable of stack "General clean-up"
      put it into tbgColor
      put convert_to_hex(tbgColor) into tbgColor
      --
      switch textstyle of item pColumn of fld pTable of stack "General clean-up"
         case "italic"
            put "<i>" into pSearchHTMLstart
            break
         case "bold"
            put "<b>" into pSearchHTMLstart
            break
         case "bold,italic"
            put "<i><b>" into pSearchHTMLstart
            break
         default
            put ""  into pSearchHTMLstart
      end switch
      --
      put "<font" after pSearchHTMLstart
      if tTextColor is not "#" then
         put " color=" after pSearchHTMLstart
         put quote & tTextcolor & quote after pSearchHTMLstart
      end if
      --
      if tbgColor is not "#" then
         put " bgcolor=" after pSearchHTMLstart
         put quote & tbgColor & quote after pSearchHTMLstart
      end if
      put ">" after pSearchHTMLstart
      return pSearchHTMLstart
   end HTML_start
   
   function HTML_end pColumn, pTable
      set the itemDelimiter to tab
      --
      switch textstyle of item pColumn of fld pTable of stack "General clean-up"
         case "bold"
            put "</b>" into pSearchHTMLend
            break
         case "italic"
            put "</i>" into pSearchHTMLend
            break
         case "bold,italic"
            put "</b></i>" into pSearchHTMLend
            break
         default
            put ""  into pSearchHTMLend
      end switch
      --
      put "</font>" before pSearchHTMLend
      return pSearchHTMLend
   end HTML_end
   
   
   
   on mouseup
      ensure_locked
      structure_all_refs
      put find_key_for_highlighted_text("Unstructured") into tKey
      if tKey is not empty then
         _color_focused_ref "Structured", tKey
      end if
      correct_scroll_to_view_item "Structured", tKey
      -- unlock screen
   end mouseup
   
   function find_key_for_highlighted_text pFld
      -- Grab key of currently highlighted text
      -- e.g. {Smith1993}
      put the backgroundcolor of fld "bibitem bg" of stack settings \
            into tBGcolor
      put the number of lines of fld pFld into tLines
      put empty into tHighlightedText
      -- should speed up this extraction:
      repeat with i = 1 to tLines
         if the backgroundcolor of line i of fld pFld is tBGcolor then
            put line i of fld pFld & return after tHighlightedText
         end if
      end repeat
      if tHighlightedText is empty then
         return empty
      else
         put empty into tKey
         get matchtext( \
               tHighlightedText, \
               "(?s)\\bibitem(?:\[.+?\])?({.+?})", \
               tKey)
         return tKey
      end if
   end find_key_for_highlighted_text
   
   on _structure_refs_just_imported
      _do_preliminary_ref_clean_up
      structure_all_refs
   end _structure_refs_just_imported
   
   on _do_preliminary_ref_clean_up
      put fld "Unstructured" into sRefs
      put _clean_up_docx_refs_for_structuring(sRefs) into sRefs
      put _clean_up_textquotedblleft_right(sRefs) into sRefs -- needs better name later
      put _remove_extra_braces_in_natexlab(sRefs) into sRefs
      put _remove_leading_trailing_spaces_each_line(sRefs) into sRefs
      put _insert_two_returns_at_end(sRefs) into sRefs
      put _multiple_returns_to_two_returns(sRefs) into sRefs
      put _replace_nonbreaking_space(sRefs) into sRefs
      put sRefs into fld "Unstructured"
      put _remove_comments(sRefs) into sRefs
      --      put _remove_nested_braces(sRefs) into sRefs
      put _remove_word_conversion_anomalies(sRefs) into sRefs
      -- clean up multiple returns
      put replacetext(sRefs, "\n+(?=\\bibitem)", return & return) into sRefs
      -- "\ " to " "
      put replacetext(sRefs, "(?<!\\)(\\ +)", space) into sRefs
      put sRefs into fld "Unstructured"
   end _do_preliminary_ref_clean_up
   
   function _remove_extra_braces_in_natexlab pText
      -- \natexlab{{\em a\/}} > \natexlab{\em a\/}
      get sunnYreplace(ptext, "natexlab{{\\em\s+(.)\\\/}}", "natexlab{\\em \1\\/}", pText)
      return pText
   end _remove_extra_braces_in_natexlab
   
   function _clean_up_textquotedblleft_right pText
      put replacetext(pText, "(\\textquotedblleft\s*)", "``") into pText
      put replacetext(pText, "(\\textquotedblright\s*)", "''") into pText
      put _remove_two_slashes_at_end_of_line(pText) into pText
      return pText
   end _clean_up_textquotedblleft_right
   
   function _remove_two_slashes_at_end_of_line pText
      put replacetext(pText, "(\\\\\s*\n)", return&return) into pText
      return pText
   end _remove_two_slashes_at_end_of_line
   
on structure_all_refs
   set the cursor to watch
   ensure_locked
   --
   put empty into fld "Structured"
   put fld "Unstructured" into sRefs
   put _remove_fake_bibitems(sRefs) into sRefs
   structure_refs_one_by_one
   abbreviate_journals
   --
   _change_tech_report_to_other
   put convert_diacritics_to_tex(sRefs) into sRefsNoDiacritic
   put color_all_tags_in_refs(sRefs) into tHtml
   put color_all_tags_in_refs(sRefsNoDiacritic) into tHtmlNoDiacritic
   set the cHTML of fld "Structured" to tHTML
   set the cHTMLNoDiacritic of fld "structured" to tHtmlNoDiacritic
   if sOriginalRefs is not empty then
      put sOriginalRefs into fld "Unstructured"
   end if
   update_structured_view_for_refs
   unlock screen
end structure_all_refs

function    _refs_remove_no_of_pages_from_artnum pRef
   get sunnYreplace(pRef, "\\artnum{(.+?)\s+\([0-9]+pp\)}", "\\artnum{\1}", pRef)
   return pRef
end _refs_remove_no_of_pages_from_artnum
   
function _clean_up_docx_refs_for_structuring pRefs
   /*
   Docx2TeX conversion puts some anomalies into the text, e.g. \textendash{}
         for en-dash. We could write some complex regex matches, but it is 
   more efficient to do some cleaning up first, then use regex. 
   */
   if not (fld "main text" contains "docx2tex") then
      return pRefs
   end if
   -- ", }ABC" > ",} ABC":
   put replacetext(sRefs, ",\s+}(?!\s)", ",} ") into pRefs
   -- "\textit{. }" > ". "
   put replacetext(pRefs, "(\\textit{\.\s+})", "\. ") into pRefs
   put replacetext(pRefs, "(\\textit{\.})", "\.") into pRefs
   put replacetext(pRefs, "(\\textit{,\s+})", ", ") into pRefs
   put replacetext(pRefs, "(\\textit{,})", ",") into pRefs
   put replacetext(pRefs, "(\\textit{\s+})", " ") into pRefs
   -- " }" > "} "
   put replacetext(pRefs, "((?!\\) })", "} ") into pRefs
   -- " )" > ") "
   put replacetext(pRefs, "((?!\\) \))", ") ") into pRefs
   --
   put replacetext(pRefs, "({\\grqq})", quote) into pRefs
   put replacetext(pRefs, "((?<=[0-9])\$[-–]\$(?=[0-9]))", "--") into pRefs
   put replacetext(pRefs, "(‒)", "--") into pRefs
   -- Divya I put in following lines on 29 Oct 2019
   put replacetext(pRefs, "(\\textendash{})", "--") into pRefs
   put replacetext(pRefs, "(“)", "``") into pRefs
   put replacetext(pRefs, "(”)", "''") into pRefs
   --   put replacetext(pRefs, "(,}\s+)", "}, ") into pRefs
   
   return pRefs
end _clean_up_docx_refs_for_structuring
   
   on update_structured_view_for_refs
      if the hilite of btn "View diacritics" is true then
         set the HTMLText of fld "structured" to the cHTML of fld "structured"
      else
         set the HTMLText of fld "structured" to the cHTMLNoDiacritic of fld "structured"
      end if
      highlight_suspect_content_in_structured
      --
      put find_key_for_highlighted_text("Unstructured") into tKey
      if tKey is not empty then
         _color_focused_ref "Structured", tKey
      end if
      correct_scroll_to_view_item "Structured", tKey
      remember_clean_bib_status
   end update_structured_view_for_refs
   
   --on create_borders_for_refs
   --   put fld "structured" into tText
   --   put empty into tStart; put empty into tEnd
   --   repeat until matchtext(tText,  \
   --         "(?is)(\\end{Journal|book|inbook|other|conference|tech_report})" \
   --         ) is false
   --      put the number of lines of tText into tTotal
   --      repeat with i = tTotal down to 1
   --         put line i of tText into tLine
   --         if matchchunk(tLine,  \
   --               "\end{(Journal|book|inbook|other|conference|tech_report)}", \
   --               tStart,  \
   --               tEnd) then
   --            put tLine into tLastLine
   --            put char tStart to tEnd of tText into tRefType
   --            repeat with i = tLastLine down to 1
   --               if matchchunk(tLine, "(?is)((?<=\n)\\bibitem)")
   --            end repeat
   --         end if
   --      end repeat
   --   end repeat
   --end create_borders_for_refs
   
   on highlight_suspect_content_in_structured
      ensure_locked
   put fld "structured" into tStructured
   put the backgroundcolor of fld "suspect color" of stack "settings" into tSuspectColor
   put the backgroundcolor of fld "suspect jnl color" of stack "settings" into tSuspectJnlColor
   put empty into tStart; put empty into tEnd
   repeat  with i = 1 to the number of lines of tStructured
      put line i of tStructured into tLine
      if matchchunk(tLine, sSuspectMark) \
            AND the backgroundcolor of char 1 of line i of fld "Structured" \
            is not tSuspectColor then
         put offset("{", tLine) into tBraceOffset
         set the backgroundcolor of char tBraceOffset +1 \
               to -2 of line i of fld "Structured" to tSuspectColor
      end if
      if matchchunk(tLine, sSuspectJnlMark) \
            AND the backgroundcolor of char 1 of line i of fld "Structured" \
            is not tSuspectJnlColor then
         put offset("{", tLine) into tBraceOffset
         set the backgroundcolor of char tBraceOffset +1 \
               to -2 of line i of fld "Structured" to tSuspectJnlColor
      end if
   end repeat
   replace sSuspectMark with "" in fld "structured" preserving styles
   replace sSuspectJnlMark with "" in fld "structured" preserving styles
   unlock screen
end highlight_suspect_content_in_structured
   
   function _remove_nested_braces pText
      get sunnYreplace(pText, "{{([^{}]+)}}", "{\1}", pText)
      return pText
   end _remove_nested_braces
   
   function _remove_word_conversion_anomalies pText
      put replacetext(pText, "(\\textit{\.})", ".") into pText
      return pText
   end _remove_word_conversion_anomalies
   
   function _replace_nonbreaking_space pText
      replace " " with space in pText
      return pText
   end _replace_nonbreaking_space
   
   function _insert_two_returns_at_end pText
      if char -1 of pText is return \
            AND char -2 of pText is return then
         -- do nothing
      else
         put return & return after pText
      end if
      return pText
   end _insert_two_returns_at_end
   
   on remember_clean_bib_status
      set the cHtmlText of fld "Structured" to the htmlText of fld "Structured"
      set the cScroll of fld "Structured" to the vscroll of fld "Structured"
      set the cSelectedChunk of fld "Structured" to \
            the selectedChunk of fld "Structured"
   end remember_clean_bib_status
   
   on recall_clean_bib_status
      set the htmlText of fld "Structured" to the cHtmlText of fld "Structured"
      set the vScroll of fld "Structured" to the cScroll of fld "Structured"
      put word 2 of the cSelectedChunk of fld "Structured" into tFrom
      put word 4 of the cSelectedChunk of fld "Structured" into tTo
      select word tFrom to tTo of fld "Structured"
   end recall_clean_bib_status
   
   
   /**
   * structure_refs_one_by_one
   * command
   * Take each ref in turn from sRef, clean, and add to sCleanedRefs
   */
   on structure_refs_one_by_one
      put empty into tPatternsEncountered -- list of patterns found
      put return & return into sOriginalRefs
      put empty into sCleanedRefs
      put _ensure_two_returns_at_start(sRefs) into sRefs
      repeat forever
         --
         put empty into tStart
         put empty into tEnd
         -- find next ref:
         get matchchunk( \
               sRefs, \
               "(?s)(\n\n.+?)(?=\n\n)", \
               tStart, \
               tEnd )
         if tStart is empty then
            -- no more refs
            exit repeat
         end if
         put empty into char 1 to tStart-1 of sRefs -- remove everything before 1st bibitem
         put take_out_next_ref(sRefs) into tNextRef
         set the cCurrentRef of fld "unstructured" to tNextRef
         put return after tNextRef -- add a return to make regex easier
         put convert_tex_to_diacritics(tNextRef) into tNextRef
         get sunnYreplace(tNextRef, "\\sameauthor\[(.+?)\]", "\1", tNextRef)
         put find_pattern_for_one_ref(tNextRef) into tPatternA
         put format_current_ref(tNextRef, tPatternA) into tNextRef
         -- mark all journals as suspect and later remove if Abbrev found
         put tPatternA["Pattern_name"] into tCurrentPattern
         if tCurrentPattern is not in tPatternsEncountered \
               AND tCurrentPattern is not empty then
            put tCurrentPattern & return after tPatternsEncountered
         end if
         put tNextRef & return & return after sCleanedRefs
         put the cCurrentRef of fld "Unstructured" & return&return after sOriginalRefs
      end repeat
      put empty into char -1 of tPatternsEncountered -- delete return character
      put tPatternsEncountered into fld "Patterns"
      put sCleanedRefs into sRefs
      put _multiple_returns_to_two_returns(sRefs) into sRefs
      put _multiple_returns_to_two_returns(sOriginalRefs) into sOriginalRefs
   end structure_refs_one_by_one
   
   function _ensure_two_returns_at_start pText
      if char 1 of pText is not return and char 2 of pText is not return then
         put return & return before pText
      end if
      return pText
   end _ensure_two_returns_at_start
   
   function _ensure_two_returns_at_end pText
      if char -2 to -1 of pText is not return&return then
         put return & return after pText
      end if
      return pText
   end _ensure_two_returns_at_end
   
   
function queries
   put empty into tQueries
   switch sRef_type
      case "journal"
         if sJtitle is not empty \
               AND sVolume is not empty \
               AND sFpage is empty then
            put option_for_queries() into tAuRef
            put tAuRef & ": Please provide page(s)/article number." into tQuery
            put insert_one_query(tQuery) after tQueries
         end if
         break
      case "inbook"
         if sPublisher is empty then
            put option_for_queries() into tAuRef
            put tAuRef & ": Please provide the name of publisher." into tQuery
            put insert_one_query(tQuery) after tQueries
         end if
         break
   end switch
   return tQueries
end queries
   
   function option_for_queries
      put sOption into tAuRef
      put empty into char 1 of tAuRef -- delete [
      put empty into char -1 of tAuRef -- delete ]
      -- remove text after date
      
      put replacetext(tAuRef, "(\s*\(\d\d\d\d).+", "") into tAuref
      put sYear into tYear
      put char -1 of tYear into tSuffix
      if matchchunk(tSuffix, "([a-z])") then
         put "{\it " & tSuffix & "}" into char -1 of tYear
      end if
      put "~(" & tYear & ")" after tAuRef
      replace "\and" with "\&" in tAuRef
      -- make year suffix italic
      return tAuRef
   end option_for_queries
   
   function insert_one_query tQuery
      --   get sunnYreplace(sOption, "\[(.+?\d\d\d\d.+?\)).+", "\1", tShortCitation)
      put "\xmlpi{\begin{query}" & return  \
            & "{Au:" && tQuery & "}" & return \
            & "\end{query}}" into tQuery
      return tQuery
   end insert_one_query
   
   on clean_up_ref_components
      put _replace_tilde_return_and_spaces_to_space(sOption) into sOption
      put _replace_etal(sOption) into sOption
      --
      put _remove_leading_trailing_spaces(sFpage) into sFpage
      put _remove_leading_trailing_spaces(sLpage) into sLpage
      get _clean_up_and_tag_ref_authors()
      get _clean_up_and_tag_editor_list()
      get _remove_unwanted_returns()
      --
      put _replace_tilde_return_and_spaces_to_space(sAtitle) into sAtitle
      put _remove_full_stop_at_end(sAtitle) into sAtitle
      put _remove_unwanted_braces_if_no_slash(sAtitle) into sAtitle
      clean_up_sAtitle
      --
      put _replace_tilde_return_and_spaces_to_space(sJtitle) into sJtitle
      --
      put _replace_tilde_return_and_spaces_to_space(sBktitle) into sBktitle
      put sBktitle && sBktitle_cont into sBktitle
      put _remove_braces_start_end(sBktitle) into sBktitle
      --
      put _remove_Vol(sBkstitle) into sBkstitle
      --
      put _replace_tilde_return_and_spaces_to_space(sArxiv) into sArxiv
      --
      put _replace_tilde_return_and_spaces_to_space(sPublisher) into sPublisher
      put _remove_city(sPublisher) into sPublisher
      put _insert_Ch_before_chapter(sBibchap) into sBibchap
      put _brackets_around_to_appear(sPost) into sPost
   end clean_up_ref_components
   
   function _remove_Vol pText
      replace "Vol. " with "" in pText
      return pText
   end _remove_Vol
   
   function _replace_etal pText
      put replacetext(pText, "((\\em\s+)?et[\s~]+al\.\s*(\\\/)?\s*)", "\etal") into pText
      put replacetext(pText, "({\\etal})", "\etal ") into pText
      put replacetext(pText, "(\\etal\s+)(?![A-ž])", "\etal") into pText
      return pText
   end _replace_etal
   
   function _remove_braces_start_end pText
      if char 1 of pText is "{" \
            AND char -1 of pText is "}" \
            AND char -2 of pText is not "\\"
      then
         put empty into char 1 of pText; put empty into char -1 of pText
      end if
      return pText
   end _remove_braces_start_end
   
   function _insert_Ch_before_chapter pChap
      if pChap is not empty then
         put "Ch.~" before pChap
      end if
      return pChap
   end _insert_Ch_before_chapter
   
   function _brackets_around_to_appear pText
      replace "to appear" with "(to appear)" in pText
      return pText
   end _brackets_around_to_appear
   
   on _create_Otitle_for_other
      -- arXiv
      if sVolume is empty \
            AND sIssue is empty \
            AND sFpage is empty \
            AND sLpage is empty \
            AND sJtitle contains "arXiv" \
            then
         put "other" into sRef_type
         put extract_arXiv_from_jtitle(sJtitle) into tArxiv
         put sYear & space into sOtitle
         put sAtitle & ". \textit{Preprint}, \arxiv{" & tArxiv & "}" \
               after sOtitle
         put empty into sJtitle
         put empty into sYear
      end if
      -- working paper
      get the cCurrentRef of fld "unstructured"
      if matchtext(it, "(?isx)(working\s+paper)") then
         put "``" & sAtitle & "''" && "Working paper," && sPublisher && "(" & sYear & ")" \
               into sOtitle
         put empty into sYear
      end if
   end _create_Otitle_for_other
   
   function extract_arXiv_from_jtitle pText
      put empty into tStart
      put empty into tEnd
      get matchchunk(pText, "(\d\d\d\d\.\d\d\d\d[0-9]+)", tStart, tEnd)
      put char tStart to tEnd of pText into tArxiv
      return tArxiv
   end extract_arXiv_from_jtitle
   
   function convert_page_to_artnum pRef
      if the number of chars of sFpage > 4 \
            AND sLpage is empty then
         put replacetext(pRef, "\\fpage", "\artnum") into pRef
      end if
      return pRef
   end convert_page_to_artnum
   
   function _remove_full_stop_at_end pRef
      put replacetext(pRef, "(\.\s*$)", "") into pRef
      return pRef
   end _remove_full_stop_at_end
   
   on clean_up_sAtitle
      -- inbook sometimes is in form \at{...}
      if sAtitle begins with "\at{" AND sAtitle ends with "}" then
         put empty into char 1 to 4 of sAtitle
         put empty into char -1 of sAtitle
      end if
      -- additionally inbook sometimes is in form {...}
      if sAtitle begins with "{" AND sAtitle ends with "}" then
         put empty into char 1 of sAtitle
         put empty into char -1 of sAtitle
      end if
   end clean_up_sAtitle
   
   function _remove_city pText
      put replacetext( \
            pText, \
            "(.+\:\s*)", \
            "") \
            into pText
      return pText
   end _remove_city
   
   on empty_ref_elements
      put empty into sOption
      put empty into sKey
      put empty into sRef_type
      put empty into sAuthors
      put empty into sAtitle
      put empty into sJtitle
      put empty into sVolume
      put empty into sIssue
      put empty into sYear
      --   put empty into sYearSuffix1 -- unused?
      --   put empty into sYearSuffix2
      put empty into sEditors
      put empty into sEditortag
      put empty into sFpage
      put empty into sLpage
      put empty into sBibchap
      put empty into sBktitle
      put empty into sBktitle_cont
      put empty into sBkstitle
      put empty into sEditors
      put empty into sEdition
      put empty into sPublisher
      put empty into sDOI
      put empty into sPbibdoi
      put empty into sPart
      put empty into sArxiv
      put empty into sOtitle
      put empty into sMisc
      put empty into sPost
      put empty into sReport
      put empty into sOrg
      put empty into sPlace
   end empty_ref_elements
   
   function remove_empty_tags pText
      put replacetext(pText, "((?is)\\[A-Za-z]+{\n*}\n)", "") into pText
      return pText
   end remove_empty_tags
   
   function remove_empty_lines pText
      put replacetext(pText, "(\n+)", return) into pText
      return pText
   end remove_empty_lines
   
   function remove_spaces_inside_curly_braces pText
      put replacetext(pText, "({ +)", "{") into pText
      put replacetext(pText, "( +})", "}") into pText
      return pText
   end remove_spaces_inside_curly_braces
   
   function _remove_unwanted_returns pText
      put replacetext(pText, "(?s)[\s]+", " ") into pText
   end _remove_unwanted_returns
   
   function _remove_blanks_at_start ptext
      put replacetext(pText, "^\s*", "") into pText
      return pText
   end _remove_blanks_at_start
   
   function _double_slash_to_space pText
      put replacetext(pText, "((?<!\\)\\\\(?=\s))", " ") into pText
      return pText
   end _double_slash_to_space pText
   
   
   function _remove_blanks_at_end ptext
      put replacetext(pText, "\s*$", "") into pText
      return pText
   end _remove_blanks_at_end
   
   function _remove_all_blanks pText
      put replacetext(pText, "\s*", "") into pText
      return pText
   end _remove_all_blanks
   
   function _clean_up_and_tag_ref_authors
      if the label of btn "Journal" is "JFQ" then
         get _change_comma_to_semicolon_jfq()
      end if
      if sAu_Minor_Sep is "space" then
         put " " into sAu_Minor_Sep
      end if
      if sAu_minor_sep_1st is "space" then
         put " " into sAu_minor_sep_1st
      end if
      if sAu_Major_Sep is "space" then
         put " " into sAu_Major_Sep
      end if
      if sAu_Prefix is "none" then
         put empty into sAu_Prefix
      end if
      if sAu_Suffix is "none" then
         put empty into sAu_Suffix
      end if
      put tag_names_refs(sAuthors) into sAuthors
   end _clean_up_and_tag_ref_authors
   
function _change_comma_to_semicolon_jfq
   set the itemdelimiter to comma
   if the number of items of sAuthors is 3 then
      -- e.g. Smith, J, and P. Doe
      put item 1 of sAuthors & comma & item 2 of sAuthors & ";"  \
            & item 3 of sAuthors into sAuthors
   end if
end _change_comma_to_semicolon_jfq
   
   function _clean_up_and_tag_editor_list
      put " " into sAu_Minor_Sep
      put "," into sAu_Major_Sep
      put empty into sAu_Prefix
      put empty into sAu_Suffix
      put "John Smith" into sAu_order
      put "N/A" into sAu_order_1st
      put tag_names_refs(sEditors) into sEditors
      replace "\gn" with "\edgn" in sEditors
      replace "\sn" with "\edsn" in sEditors
   end _clean_up_and_tag_editor_list
   
   
   function tag_names_refs pNames
      put empty into tTagged
      put _reverse_author_one_if_needed(pNames) into pNames
      set the itemdelimiter to sAu_major_sep
      put replace_and_ampersand_etc(pNames) into pNames
      put _convert_return_to_space(pNames) into pNames
      if sAu_major_sep is sAu_minor_sep then
         put the number of items of pNames into tAuthorPart
         put empty into tCorrected
         repeat with i = 1 to tAuthorPart - 1 step 2
            put item i of pNames & sAu_minor_sep &  \
                  item i + 1 of pNames &  return \
                  after tCorrected
         end repeat
         put empty into char -1 of tCorrected
         put "•" into sAu_major_sep
         replace return with sAu_major_sep in tCorrected
         put tCorrected into pNames
      end if
      set the itemdelimiter to sAu_major_sep
      put the number of items of pNames into tAuthorCount
      repeat with i = 1 to tAuthorCount
         set the itemdelimiter to sAu_major_sep
         put item i of pNames into tName
         if sAu_prefix is not empty then
            put remove_author_prefix(tName) into tName
         end if
         if sAu_suffix is not empty then
            put remove_author_suffix(tName) into tName
         end if
         put remove_spaces_not_needed(tName) into tName
         put _replace_tilde_return_and_spaces_to_space(tName) into tName
         set the itemdelimiter to sAu_minor_sep
         put _remove_unwanted_braces_if_no_slash_in_text_in_name(tName, sAu_minor_sep) into tName
         if word 1 of sAu_Order begins with "J" then
            put prelims_given_name_first(tName, sAu_minor_sep) into tName
         else if word 1 of sAu_Order is "Smith" then
            put surname_first(tName, sAu_minor_sep) into tName
         end if
         put tName & return after tTagged
      end repeat
      put empty into char -1 of tTagged
      put _mark_empty_name_component(tName) into tName
      return tTagged
   end tag_names_refs
   
   function _mark_empty_name_component pName
      put replacetext(pName, "(\\gn{\s*})", "\\gn{••}") into pName
      put replacetext(pName, "(\\sn{\s*})", "\\sn{••}") into pName
      return pName
   end _mark_empty_name_component
   
   function _remove_unwanted_braces_if_no_slash_in_text_in_name pName, pAuMinorSep
      set the itemdelimiter to pAuMinorSep
      put item 1 of pName into tSname
      put _remove_unwanted_braces_if_no_slash(tSname) into tSname
      put tSname into item 1 of pName
      put item 2 of pName into tGname
      put _remove_unwanted_braces_if_no_slash(tGname) into tGname
      put tGname into item 2 of pName
      return pName
   end _remove_unwanted_braces_if_no_slash_in_text_in_name
   
   function _remove_unwanted_braces_if_no_slash pText
      repeat while matchchunk(pText, "{([^}]+)}") is true
         if offset("\", pText) > 0 then exit repeat
         get sunnYreplace(pText, "{([^}]+)}", "\1", pText)
      end repeat
      return pText
   end _remove_unwanted_braces_if_no_slash
   
   function _reverse_author_one_if_needed pNames
      if sAu_order_1st is not "N/A" then
         set the itemdelimiter to sAu_Major_Sep
         put item 1 of pNames into tFirstAuthor
         put empty into item 1 of pNames
         set the itemdelimiter to sAu_Minor_Sep_1st
         put item 2 of tFirstAuthor & sAu_Minor_Sep & item 1 of tFirstAuthor \
               into tFirstAuthor
         set the itemdelimiter to sAu_Major_Sep
         put tFirstAuthor into item 1 of pNames
      end if
      return pNames
   end _reverse_author_one_if_needed
   
   function _convert_return_to_space pText
      return replacetext(pText, " *\n", " ")
   end _convert_return_to_space
   
   function replace_and_ampersand_etc pName
      set the itemdelimiter to sAu_major_sep
      put "(" & itemdelimiter & "*\s+" & "(\\and\b|\band\b|\\&))" into tSearch
      put replacetext( \
            pName, \
            tSearch, \
            itemdelimiter \
            ) \
            into pName
      return pName
      
   end replace_and_ampersand_etc
   
   function surname_first pName, pDelimiter
      set the itemdelimiter to pDelimiter
      put fld "surname prefixes" of stack "settings" into tPrefixes
      split tPrefixes by return
      put item 1 of pName into tOne
      put item 2 of pName into tTwo
      put item 3 of pName into tThree
      repeat for each line L in tPrefixes
         if L is tOne & space & tTwo then
            put tOne & "~" & tTwo & "~" & tThree into item 1 to 3 of pName
            exit repeat
         else if L is tOne then
            put tOne & "~" & tTwo into item 1 to 2 of pName
            exit repeat
         end if
      end repeat
      if tOne & space & tTwo is in tPrefixes then
         put tOne & "~" & tTwo & "~" & tThree into item 1 to 3 of pName
      else
         if tOne is in tPrefixes then
            put tOne & "~" & tTwo into item 1 to 2 of pName
         end if
      end if
      put item 1 of pName into tSname
      if sAu_Case is "Upper case" then
         put _convert_UPPER_surname_to_lower(tSname) into tSname
      end if
      put item 2 to -1 of pName into tGname
      put clean_up_gname(tGname) into tGname
      put "\gn{" & tGname & "}" & return & "\sn{" & tSname & "}" into pName
      return pName
   end surname_first
   
   function prelims_given_name_first pName, pDelimiter
      set the itemdelimiter to pDelimiter
      put fld "surname prefixes" of stack "settings" into tPrefixes
      put item -3 of pName into tMinus3
      put item -2 of pName into tMinus2
      repeat for each line L in tPrefixes
         --         e.g. "van der"
         if L is tMinus3 & space & tMinus2 then
            put tMinus3 & "~" & tMinus2 & "~" & item -1 of pName \
                  into item -3 to -1 of pName
            exit repeat
         else if L is tMinus2 then
            put tMinus2 & "~" & item -1 of pName \
                  into item -2 to -1 of pName
            exit repeat
         end if
      end repeat
      put item -1 of pName into tSname
      if sAu_Case is "Upper case" then
         put _convert_UPPER_surname_to_lower(tSname) into tSname
      end if
      put item 1 to -2 of pName into tGname
      put clean_up_gname(tGname) into tGname
      put "\gn{" & tGname & "}" & return & "\sn{" & tSname & "}" into pName
      put replacetext(pName, "({ +)", "{") into pName
      put replacetext(pName, "( +})", "}") into pName
      return pName
   end prelims_given_name_first
   
   function clean_up_gname tGname
      put remove_all_dots(tGname) into tGname
      put _remove_leading_trailing_spaces(tGname) into tGname
      put _remove_braces_start_end(tGname) into tGname
      put separate_abbreviations(tGname) into tGname
      put abbreviate_given_names(tGname) into tGname
      put insert_dot_after_given_names(tGname) into tGname
      return tGname
   end clean_up_gname
   
   
   
   function remove_all_dots pText
      return replacetext(pText, "\.", " ")
   end remove_all_dots
   
   function separate_abbreviations pName
      put _remove_leading_trailing_spaces_each_line(pName) into pName
      put the length of pName into tLength
      if tLength > 3 then return pName
      if contains_lower_chars(pName) then
         return pName
      else
         repeat with i = tLength - 1 down to 1
            put space after char i of pName
         end repeat
         return pName
      end if
   end separate_abbreviations
   
   function contains_lower_chars pText
      repeat with i = 1 to the number of chars of pText
         put char i of pText into tChar
         set the caseSensitive to true
         if toLower(tChar) is tChar then
            return true
            exit contains_lower_chars
         end if
      end repeat
      return false
   end contains_lower_chars
   
   function _remove_leading_trailing_spaces_each_line pText
      put replacetext(pText, "(?<=\n|^)[ \t]+", "") into pText
      put replacetext(pText, "[ \t]+(?=\n|$)", "") into pText
      return pText
   end _remove_leading_trailing_spaces_each_line
   
   function abbreviate_given_names tGname
      if gDoNotAbbreviate is true then return tGname
      put space & tGname into tGname
      put replacetext( \
            tGname, \
            "((?<=\p{Lu})\p{Ll}+)", \
            "" \
            ) \
            into tGname
      put empty into char 1 of tGname
      return tGname
   end abbreviate_given_names
   
   function insert_dot_after_given_names tGname
      put space & tGname & space into tGname
      -- put dot if no dot after cap letter
      -- note cap letter can be unicode, e.g. Ł.
      -- see https://www.regular-expressions.info/unicode.html for explanation
      put replacetext( \
            tGname, \
            "((?<=\p{Lu})\s+(?!\.))", \
            ". ") \
            into tGname
      -- put space after dot if none
      put replacetext( \
            tGname, \
            "(\.(?=\p{Lu}))", \
            ". ") \
            into tGname
      --   Put dot before dash if none
      put replacetext( \
            tGname, \
            "((?<=\p{Lu})-)", \
            ".-") \
            into tGname
      put replacetext(tGname, "( +-)", "-") into tGname
      put _remove_leading_trailing_spaces_each_line(tGname) into tGname
      return tGname
   end insert_dot_after_given_names
   
   
   function remove_author_prefix pName
      put force_to_regexp(sAu_Prefix) into tPrefix
      put "(^ *" & tPrefix & ")" into tSearch
      put replacetext( \
            pName, \
            tSearch, \
            "" \
            ) \
            into pName
      return pName
   end remove_author_prefix
   
   function remove_author_suffix pName
      put force_to_regexp(sAu_Suffix) into tSuffix
      put "( *" & tSuffix & "\s*$)" into tSearch
      put replacetext( \
            pName, \
            tSearch, \
            "" \
            ) \
            into pName
      return pName
   end remove_author_suffix
   
function build_matchText pOneRef pPatternDataA
   put pPatternDataA["Search_pattern"] into tSearchPattern
   put quote & "(?is)" & tSearchPattern & quote into tSearchPattern
   put pPatternDataA["Extracted"] into Extracted
   -- ensure no extra returns at end of Extracted field
   repeat until char -1 of Extracted is not return
      put empty into char -1 of Extracted
   end repeat
   replace return with "," in Extracted
   repeat with i = 1 to the number of items of Extracted
      put "s" before item i of Extracted
      -- e.g. Authors > sAuthors
      put "put empty into" && item i of Extracted into tCommand
      do tCommand
   end repeat
   put "get matchText(pOneRef, " & tSearchPattern & "," && extracted & ")" into tMatchText
   return tMatchText
end build_matchText

------------ old version
--function build_matchText pOneRef pPatternDataA
--      put pPatternDataA["Search_pattern"] into tSearchPattern
--      put _remove_returns_and_comments(tSearchPattern) into tSearchPattern
--      put quote & "(?is)" & tSearchPattern & quote into tSearchPattern
--      put pPatternDataA["Extracted"] into Extracted
--      repeat until char -1 of Extracted is not return
--         put empty into char -1 of Extracted
--      end repeat
--      replace return with "," in Extracted
--      repeat with i = 1 to the number of items of Extracted
--         put "s" before item i of Extracted
--         -- e.g. Authors > sAuthors
--         put "put empty into" && item i of Extracted into tCommand
--         do tCommand
--      end repeat
--      put "get matchText(pOneRef, " & tSearchPattern & "," && extracted & ")" into tMatchText
--      return tMatchText
--   end build_matchText

function _remove_returns_and_comments pText
   put replacetext(pText, "(\#.+)", "") into pText
   put replacetext(pText, "(?s)(\s*\n)", "") into pText
   return pText
end _remove_returns_and_comments
      
      
      
function correct_optional_argument pRef
   -- 2011{\natexlab{b}} > 2011b
   put _correct_natexlab(pRef) into pRef
   -- remove extra outer braces
   put quick_count(pRef, "\\sn{") into tAuthorCount
   put empty into tStart; put empty into tEnd
   get matchchunk(pRef,  \
         "\[[^\[\]]+\(\d\d\d\d.*\)([^\[\]]*)\]", \
         tStart, \
         tEnd \
         )
   --
   -- remove second part if > 3 authors
   if tAuthorCount > 3 then
      put empty into char tStart to tEnd of pRef
   end if
   -- correct \etal
   put replacetext(pRef, "({\\em et[ ~]al.})", "\etal") into pRef
   put empty into tStart
   put empty into tEnd
   get matchchunk( \
         pRef, \
         "\\bibitem.+(\\\&)", \
         tStart, \
         tEnd\
         )
   if tStart is not empty then
      put "\and" into char tStart to tEnd of pRef
   end if
   put replacetext(pRef, "((?is),(?! ))", ", ") into pRef
   --      put _et_al_to_etal_in_option(pRef) into pRef
   
   return pRef
end correct_optional_argument
   
   function _correct_natexlab pRef
      get sunnYreplace(pRef, \
            "(?sx)(\d\d\d\d){\\natexlab{.*?(?:\\em\s+)? ([a-z]).+?}", \
            "\1\2",  \
            pRef)
      return pRef
   end _correct_natexlab
   
   function align_snames pRef
      put 0 into tMaxlength
      repeat for each line L in pRef
         if offset("\gn{", L) >0 then
            get matchtext(L, "(\\gn{.+?})", tMatch)
            put the length of tMatch into tLength
            if tLength > tMaxLength then put tLength into tMaxLength
         end if
      end repeat
      put empty into tPadded
      repeat for each line L in pRef
         if offset("\gn{", L) >0 then
            get matchtext(L, "(\\gn{.+?})", tMatch)
            put tMaxLength - (the length of tMatch) into tSpacesNeeded
            repeat with i = 1 to tSpacesNeeded
               put " " before L
            end repeat
            put L & return after tPadded
         else
            put L & return after tPadded
         end if
      end repeat
      put empty into char -1 of tPadded
      return tPadded
   end align_snames
   
   
   
   
   function remove_spaces_not_needed tText
      put replacetext(tText, "(^ +)", "") into tText
      put replacetext(tText, "( +$)", "") into tText
      return tText
   end remove_spaces_not_needed
   
   function _remove_all_spaces pText
      put replacetext(pText, "( +)", "") into pText
      return pText
   end _remove_all_spaces
   
   function take_out_next_ref
      --   put "((?is)\\bibitem.+?(?=\n\n))" into tBibitemSearch
      --   put "((?is)\n\n.+?(?=\n\n))" into tBibitemSearch
      
      put "((?is).+?(?=\n\n))" into tBibitemSearch
      put empty into tStart; put empty into tEnd
      get matchchunk( \
            sRefs, \
            tBibitemSearch, \
            tStart, \
            tEnd)
      put char tStart to tEnd of sRefs into tNextRef
      put the length of tNextRef into tLength
      put empty into char 1 to tLength of sRefs
      return tNextRef
   end take_out_next_ref
   
   function remove_spaces_not_needed pRef
      -- spaces preceded by return
      put "( *\n *)" into tSearch
      put return into tReplace
      put replacetext(pRef, tSearch, tReplace) into pRef
      return pRef
   end remove_spaces_not_needed
   
   
   function remove_punctuations_outside_tags pRef
      put "(}[ ,\.\\\&]+\n)" into tSearch
      put replacetext(pRef, tSearch, "}" & return) into pRef
      return pRef
   end remove_punctuations_outside_tags
   
   
on abbreviate_journals
   put sJournals into tJournals
   put _insert_tilde_in_journal_abbreviations(tJournals) into tJournals
   set the itemdelimiter to tab
   repeat with i = 1 to the number of lines of tJournals
      put item 1 of line i of tJournals into tJnl
      put item 2 of line i of tJournals into tAbbrev
      put regex_for_Journal(tJnl) into tSearch
      put "\jtitle{" & tAbbrev & "}" into tReplace
      if matchtext(sRefs, tSearch) is true then
         put replacetext( \
               sRefs, \
               tSearch, \
               tReplace) \
               into sRefs
         --         exit abbreviate_journals
      end if
   end repeat
end abbreviate_journals

function _insert_tilde_in_journal_abbreviations pText
   -- put tilde after first word if <= 4 chars
   get sunnYreplace(pText,  "(\t[^\s]{1,4})\s", "\1~", pText)
   -- put tilde before last word if <= 4 chars
   get sunnYreplace(pText,  "\s([^\s]{1,4})\n", "~\1\n", pText)
   return pText
end _insert_tilde_in_journal_abbreviations
   
   function regex_for_Journal pJnl
   -- prepare filler word regex
   put filler_regex() into tFillerRegex
   put filler_words() into tStartRegex
   put replacetext( \
         pJnl, \
         " +", \
         tFillerRegex) \
         into pJnl
   put "(?i)\\jtitle{(" & tStartRegex & "[ ~]+)* *" &   \
         pJnl & "[\.\w*]*" & sSuspectJnlMark & "}" into pJnl
   return pJnl
end regex_for_Journal

function filler_regex
      put filler_words() into tFillerWords
      put "[\.\w*]* *((" & tFillerWords & ")[ ~]+)*" into tRegex
      return tRegex
   end filler_regex
   
   function filler_words
      put empty into tRegex
      set the itemdelimiter to return
      repeat for each item F in sFillerWords
         put replacetext(F, " ", " +") into F
         put F & "|" after tRegex
      end repeat
      put empty into last char of tRegex
      return tRegex
   end filler_words
   
   
   function _replace_tilde_return_and_spaces_to_space pText
      put replacetext(pText, "(?s)(\n)", " ") into pText
      put replacetext(pText, "((?<!\\)\\ )", " ") into pText -- ignore \\
      put replacetext(pText, "((?<!\\)~)", " ") into pText -- ignore if \~
      put replacetext(pText, "(\\\/)", "") into pText
      put replacetext(pText, "( +)", " ") into pText
      return pText
   end _replace_tilde_return_and_spaces_to_space
   
   function _multiple_spaces_to_single_space pText
      put replacetext(pText, "  +", " ") into ptext
      return pText
   end _multiple_spaces_to_single_space
   
   function color_all_tags_in_refs pText
      put the cNowProcessing of group "Structuring" into sNowProcessing
      put the number of btns of group sNowProcessing \
            of stack "settings" into tNumber
      repeat with i = 1 to tNumber
         put the short name of btn i of \
               group sNowProcessing of stack "settings" into tTag
         put color_tag(pText, tTag) into pText
      end repeat
      if sNowProcessing is "references" then
         put replacetext(pText, "(\n\\sn{)", " \sn{") into pText
      end if -- should put outside color tags
      repeat for each line L in pText
         put "<p>" & L & "</p>" & return after tFinalResult
      end repeat
      return tFinalResult
   end color_all_tags_in_refs
   
   function color_tag tRefs, tTag
      put the millisecs into ms
      put the textColor of btn tTag of group sNowProcessing \
            of stack "settings" into tColor
      put convert_to_hex(tColor) into tColor
      put "<b><font color=" & tColor & ">" into tColorTag
      put "</font></b>" into tEndTag
      -- works with { or [
      put "(\\" & tTag & "({|\[))" into tTag
      put empty into tResult
      repeat forever
         put empty into tStart
         put empty into tEnd
         get matchchunk( \
               tRefs, \
               tTag, \
               tStart, \
               tEnd)
         if tStart is empty then
            exit repeat
         end if
         put char 1 to tEnd of tRefs after tResult
         put empty into char 1 to tEnd of tRefs
         put empty into tStart
         put empty into tEnd
         get matchchunk( \
               tRefs, \
               "(\n|$)", \
               tStart, \
               tEnd)
         if tStart is empty then
            exit repeat
         end if
         put char 1 to tEnd - 2 of tRefs into tToTag
         put empty into char 1 to tEnd - 2 of tRefs
         put tColorTag & tToTag & tEndTag into tTagged
         put tTagged after tResult
      end repeat
      put tRefs after tResult
      --      answer the milliseconds - ms
      return tResult
   end color_tag
   
   function _change_case_name_to_lower pName
      if _all_letters_are_upper_case then
         put toLower(pName) into pName
         put toUpper(char 1 of pName) into Char 1 of pName
      end if
      return pName
   end _change_case_name_to_lower
   
   function _all_letters_are_upper_case pText
      repeat for each char C in pText
         get chartonum(toUpper(C))
         if it is not chartonum(C) then
            return false
         end if
      end repeat
      -- if we get this far then all chars are upper case
      return true
   end _all_letters_are_upper_case
   
   
   
   --Command _replace_text_before_and_after_bib
   --   put sTheTop before sRefs
   --   put sTheBottom after sRefs
   --end _replace_text_before_and_after_bib
   
   on _change_tech_report_to_other
      replace "{tech_report}" with "{other}" in sRefs
   end _change_tech_report_to_other
   
   
   function _remove_comments pText
      put replacetext(pText, "((?<=\n) *%.*\n)", "") into pText -- remove "%" in empty lines
      put replacetext(pText, "((?<!\\)%.*)", "") into pText -- remove "%..." at end of lines
      return pText
   end _remove_comments
   
   function _multiple_returns_to_two_returns pText
      put replacetext(pText, "(\n\n\n+)", return & return) into pText
      return pText
   end _multiple_returns_to_two_returns
   
   function _multiple_returns_to_three_returns pText
      put replacetext(pText, "(\n\n\n+)", return & return & return) into pText
      return pText
   end _multiple_returns_to_three_returns
   
   
   function _multiple_returns_to_single_return pText
      put replacetext(pText, "(\n\n+)", return) into pText
      return pText
   end _multiple_returns_to_single_return
   
function find_pattern_for_one_ref pOneRef
   repeat for each line L in sPatternOrder
      put sPatternsA[L]["Search_pattern"] into tSearchPattern
      put "(?is)(" & tSearchPattern & ")" into tSearchPattern
      get matchchunk( \
            pOneRef, \
            tSearchPattern \
            )
      if it is true then
         return sPatternsA[L]
         exit repeat
      end if
   end repeat
   return empty
end find_pattern_for_one_ref

function format_current_ref pOneRef tPatternDataA
   -- pOneRef has been converted to diacritics
   if tPatternDataA is empty then
      return pOneRef
   end if
   empty_ref_elements -- sAuthor, sTitle etc
   repeat with i = 1 to the number of items of sPatternColumns
      put item i of sPatternColumns into tColumn
      put "put tPatternDataA[" & quote & tColumn & quote & "] into" && "s" & tColumn into tCommand
      -- e.g. put tPatternDataA["Pattern_name"] into sPattern_name
      do tCommand
   end repeat
   --
   put build_matchText(pOneRef, tPatternDataA) into tMatchText
   /*
   e.g.
   get matchText(pOneRef, "(?is)(?s)\\bibitem(\[.+?\])({.+?})\n{\\sc +(.+?)}[ \n]+
   \\yr{(\d\d\d\d)([a-z])?(?:{\\natexlab{{\\em\s+(\w+)(?:\\\/)?}}})?}[ \n]+\\at{(.+?)}
         (?:\.)?[ \n]+\\jt{(.+?)}(?:[ \n]+\\bvol{(.+?)})?(?:~\((.+?)\))?(?:,?[ \n]+\\pg{(?:p\. )?
         (.+?)(?:[-–]+([^ ]+?))?})?(?:,\s*\\arxiv{(.+?)}\.)?(?:.+?)?",
         sOption,sKey,sAuthors,sYear,sYearSuffix,sYearSuffix,
   sAtitle,sJtitle,sVolume,sIssue,sFpage,sLpage,sArXiv,sMisc)
   */
   do tMatchText
   put empty into tCleanedRef
   clean_up_ref_components
   if sOption is empty then
      _generate_option
   end if
   
   if sKey is empty then
      _generate_key   
      _insert_fake_bibitem
   end if
   switch label of btn "Journal"
      case "JFQ"
         
         break
   end switch
   
   --   _remove_extra_braces_around_option
   _create_Otitle_for_other
   -- Now add components to build cleaned ref
   put "\bibitem" & sOption & sKey & return after tCleanedRef
   put "\begin{" & sRef_type & "}" & return after tCleanedRef
   put sAuthors & return after tCleanedRef
   generate_post_bibdoi -- need to reexamine (sDOI, tDOI) Kaveh
   -- mark all journals as suspect. Remove suspect mark if matched
   get the label of btn "Journal"
   if it is "FLM" or "PLA" then
      put sJtitle & sSuspectJnlMark into sJtitle
      end if
   --
   tag_suspect_values_one_ref
   switch sRef_type
      case "journal"
         put sYear & sYearSuffix into sYear
         put "\yr{" & sYear & "}" & return after tCleanedRef
         put "\atitle{" & sAtitle &"}" & return after tCleanedRef
         put "\jtitle{" & sJtitle &"}" & return after tCleanedRef
         put "\vol{" & sVolume &"}" & return after tCleanedRef
         put "\iss{" & sIssue &"}" & return after tCleanedRef
         put "\fpage{" & sFpage &"}" & return after tCleanedRef
         put "\lpage{" & sLpage &"}" & return after tCleanedRef
         put "\pbibdoi{" & sPbibdoi &"}" & return after tCleanedRef
         put "\post{" & sPost &"}" & return after tCleanedRef
         break
      case "book"
         put sYear & sYearSuffix into sYear
         put "\yr{" & sYear & "}" & return after tCleanedRef
         put "\bktitle{" & sbktitle &"}" & return after tCleanedRef
         put "\bkstitle{" & sbkstitle &"}" & return after tCleanedRef
         put "\editortag{" & sEditors &"}" & return after tCleanedRef
         put sEditors & return after tCleanedRef
         put "\edn{" & sEdition &"}" & return after tCleanedRef
         put "\publisher{" & sPublisher &"}" & return after tCleanedRef
         put "\place{" & sPlace &"}" & return after tCleanedRef
         break
      case "inbook"
         put sYear & sYearSuffix into sYear
         put "\yr{" & sYear & "}" & return after tCleanedRef
         put "\atitle{" & sAtitle &"}" & return after tCleanedRef
         put "\bktitle{" & sBktitle &"}" & return after tCleanedRef
         put "\bkstitle{" & sBkstitle &"}" & return after tCleanedRef
         put "\editortag{" & sEditors &"}" & return after tCleanedRef
         put "\fpage{" & sFpage &"}" & return after tCleanedRef
         put "\lpage{" & sLpage &"}" & return after tCleanedRef
         put "\bibchap{" & sBibchap &"}" & return after tCleanedRef
         put "\publisher{" & sPublisher &"}" & return after tCleanedRef
         put "\place{" & sPlace &"}" & return after tCleanedRef
         put "\pbibdoi{" & sPbibdoi &"}" & return after tCleanedRef
         put "\post{" & sPost &"}" & return after tCleanedRef
         break
      case "other"
         put sYear & sYearSuffix into sYear
         put "\yr{" & sYear & "}" & return after tCleanedRef
         put "\otitle{" & sOtitle &"}" & return after tCleanedRef
         break
      case "tech_report"
         put "\otitle{" after tCleanedRef
         put sYear & return after tCleanedRef
         put sBktitle & "." & return after tCleanedRef
         put "\textit{Tech. Rep.} "  after tCleanedRef
         if sReport is not empty then
            put sReport & ". "  after tCleanedRef
         end if
         put sOrg after tCleanedRef
         if sPlace is not empty then
            put "," &  sPlace after tCleanedRef
         end if
         put "}" & return after tCleanedRef
         break
   end switch
   --
   
   if sDOI is not empty then
      -- not sure needed. See above
      put "\post{\bibdoi{" & sDOI &"}}" & return after tCleanedRef
   end if
   put "\end{" & sRef_type & "}" & return after tCleanedRef
   put remove_punctuations_outside_tags(tCleanedRef) into tCleanedRef
   put correct_optional_argument(tCleanedRef) into tCleanedRef
   put remove_spaces_inside_curly_braces(tCleanedRef) into tCleanedRef
   put align_snames(tCleanedRef) into tCleanedRef
   put convert_page_to_artnum(tCleanedRef) into tCleanedRef
   put _refs_remove_no_of_pages_from_artnum (tCleanedRef) into tCleanedRef
   put remove_empty_tags(tCleanedRef) into tCleanedRef
   put remove_empty_lines(tCleanedRef) into tCleanedRef
   -- Kaveh to check:
   put _final_clean_editor_list(tCleanedRef) into tCleanedRef
   put return & queries() after tCleanedRef
   return tCleanedRef
end format_current_ref
   
on    _remove_extra_braces_around_option
   -- [{...}] > [...]
   if char 2 of sOption is "{" AND char -2 of sOption is "}" then
      put empty into char 2 of sOption
      put empty into char -2 of sOption
   end if
end _remove_extra_braces_around_option
   
   on _insert_fake_bibitem
      get the cCurrentRef of fld "Unstructured"
      put "\bibitem" & sKey & " %%% Fake bibitem" & return into char 1 to 2 of it
      set the cCurrentRef of fld "Unstructured" to it
   end _insert_fake_bibitem
   
function _option_part_1
   -- create part 1 for option
   -- e.g. Smith \etal(2015)
   put _author_surnames() into sSurnames
   put sSurnames into tPart1
   put the number of lines of tPart1 into tlines
   if tLines is 2 then
      put return & "and" & return after line 1 of tPart1
   else if tLines > 2 then
      put line 1 of tPart1 into tPart1
      put return & "\etal" after line 1 of tPart1
       else
      put line 1 of tPart1 into tPart1
   end if
   put "(" & sYear & ")" after tPart1
   return tPart1
end _option_part_1

#### _generate_option and _option_part_1 are edited on 08.11.19 by Divya

on _generate_option
   put _option_part_1() into tPart1
   -- part 2
   -- e.g. Smith, Jones, and Williams
   put sSurnames into tPart2
   --put tSurnames into tPart2
   put the number of lines of tPart2 into tlines
   if tLines > 2 then
      replace return with "," & return in tPart2
      put "and" & return before line -1 of tPart2
      put "[" & tPart1 & tPart2 & "]" into sOption
    
   else if tLines = 2 then
      put "and" & return before line -1 of tPart2
      --put "[" & tPart1 & tPart2 & "]" into sOption
      put "[" & tPart1 & "]" into sOption
   else
      put empty into tPart2
      put "[" & tPart1 & tPart2 & "]" into sOption
   end if
   -- put together
   -- e.g. [Smith \etal(2015)Smith, Jones, and Williams]
   --put "[" & tPart1 & tPart2 & "]" into sOption
   put _convert_return_to_space(sOption) into sOption
   put _multiple_spaces_to_single_space(sOption) into sOption
end _generate_option

  on _generate_key
   -- get e.g. Smith \etal(2015) then modify to get Key
   put _option_part_1() into  tKey
   put replacetext(tKey, "(\band\b)", "") into tKey -- remove "and"
   put replacetext(tKey, "([\(\)\s\n\\])", "") into tKey
   put "{" & tKey & "}" into sKey
end _generate_key

function _author_surnames
   put sAuthors into tAuthors
   put replacetext(tAuthors, "(}\n\\sn{)", tab) into tAuthors
   put replacetext(tAuthors, "(}\n\\gn{)", return) into tAuthors
   put replacetext(tAuthors, "(\\gn{)", "") into tAuthors
   put empty into char -1 of tAuthors
   put the label of btn "Journal" into tJournal
   put replacetext(tAuthors, "(.+\t)", "") into tAuthors
   return tAuthors
end _author_surnames

on tag_suspect_values_one_ref
   ----------------------- fpage and lpage ------------------
   --   No numerals in page number
   if sFpage is not empty AND matchchunk(sFpage, ".*([0-9]+?).*") is false then
      _mark_as_suspect("sFpage")
   end if
   if sLpage is not empty AND matchchunk(sLpage, ".*([0-9]+?).*") is false then
      _mark_as_suspect("sLpage")
   end if
   -- lPage < fPage
   if sFpage is a number and sLpage is a number then
      if sLpage < sFpage then
         _mark_as_suspect("sLpage")
      end if
   end if
   -- Suspect characters in fPage and lPage, e.g. space, brackets
   if matchchunk(sLpage, "([ \()])") then
      _mark_as_suspect("sLpage")
   end if
   if matchchunk(sFpage, "([ \()])") then
      _mark_as_suspect("sFpage")
   end if
   
   ---------------------- bktitle ---------------------------
   -- bktitle contains "j.", "journal" or "jnl"
   if matchchunk(sBktitle, "(?i)(\b(j\.?|journal|jnl)\b)") then
      _mark_as_suspect("sBktitle")
   end if
   ---------------------- vol ----------------------------
   --   if no digits in volume:
   -- Divya pls note. This is where we can put in any "suspect" patterns to 
   -- get attention of operators
   if matchchunk(sVolume, ".*([0-9]).*") is false then
      _mark_as_suspect("sVolume")
   end if
end tag_suspect_values_one_ref
   
   
   on _mark_as_suspect pValue
      put "put" && pValue && " & sSuspectMark into" && pValue into tCommand
      do(tCommand)
      --   return pValue & sSuspectMark
   end _mark_as_suspect
   
   function _final_clean_editor_list pRef
      if matchtext(pRef, "\\editortag") then
         put replacetext(pRef, "(?s)(\\editortag{)", "") into pRef
         get sunnYreplace(pRef, "(\\edsn{.+})}", "\1", pRef)
      end if
      return pRef
   end _final_clean_editor_list
   
   on generate_post_bibdoi
      if sJtitle is not empty \
            AND sArxiv is not empty then
         put empty into tDOI
         --         get matchtext (sArxiv, "(\d[\.\d\/]+$)", tDOI)
         put "\bibdoi{" & tDOI & "}" into sPost
      end if
   end generate_post_bibdoi
   
   
   
   on textChanged
      if the short name of this stack is not RVClean then exit textChanged
      if the hilite of btn "Live convert" is false then
         pass textChanged
      end if
      -- structuring refs and prelims
      if the short name of the target is "Unstructured" then
         ensure_locked
         --      lock messages   answer the       cScrollInteractive of fld "Structured"
         set the cScrollInteractive of fld "Unstructured" to the vscroll of fld "Unstructured"
         set the cScrollInteractive of fld "Structured" to the vscroll of fld "Structured"
         set the cSelectedChunk of fld "Unstructured" to the selectedChunk
         put word 2 of the selectedChunk into tFrom
         put word 4 of the selectedChunk into tTo
         set the cSelectFrom of fld "Unstructured" to tFrom
         set the cSelectTo of fld "Unstructured" to tTo
         set the cOriginalText of fld "Unstructured" to fld "Unstructured"
         set the cText_has_changed of fld "Unstructured" to true
         --      set the cWhen_text_changed of fld "Unstructured" to the milliseconds
         put _remove_leading_trailing_spaces_each_line(fld "Unstructured") into fld "unstructured"
         put _ensure_two_returns_at_end(fld "Unstructured") into fld "Unstructured"
         switch the cNowProcessing of group "Structuring"
            case "References"
               -- references
               -- kaveh to improve
               --            _do_preliminary_ref_clean_up
               do_live_structure_all_refs
               break
            case "Prelims"
               -- prelims
               do_live_structure_prelims
               break
         end switch
         select char tFrom to tTo of fld "Unstructured"
         if the cNowProcessing of group "Structuring" is "References" then
            put the cCurrentKey of fld "Structured" into tKey
            set the vscroll of fld "Unstructured" to the cScrollInteractive of fld "Unstructured"
            set the vscroll of fld "Structured" to the cScrollInteractive of fld "Structured"
            --         correct_scroll_to_view_item "Unstructured", tKey
            --         correct_scroll_to_view_item "Structured", tKey
         end if
      end if
      --   answer the       cScrollInteractive of fld "Structured"
      wait 10  ticks
      unlock screen
   end textChanged
   
   function _remove_fake_bibitems pRefs
      put replacetext(pRefs, "(\\bibitem.+%%% Fake bibitem.*\n)", "") into pRefs
      return pRefs
   end _remove_fake_bibitems
   
   on do_live_structure_prelims
      --   ensure_locked
      put the milliseconds into tTimeNow
      if the cText_has_changed of fld "Unstructured" is false then
         -- no key pressed since handler was last called
         exit do_live_structure_prelims
      end if
      --
      put (fld "Type delay" of stack "settings") * 1000 into tTypeDelay
      put the cWhen_text_changed of fld "Unstructured" into tWhen_text_changed
      if (tTimeNow - tWhen_text_changed) \
            > tTypeDelay then
         set the Cscroll of fld "Unstructured" to the vscroll of fld "Unstructured"
         set the Cscroll of fld "Structured" to the vscroll of fld "Structured"
         put the selectedChunk of fld "Unstructured" into tFocusedChunk
         put word 4 of tFocusedChunk into tChar -- Offset of last char selected
         if tChar is empty then
            -- no selection
            put 1 into tChar
         end if
         structure_prelims
         focus fld "Unstructured"
         select tFocusedChunk
         set the cText_has_changed of fld "Unstructured" to false
         set the vscroll of fld "Unstructured" to the Cscroll of fld "Unstructured"
         set the vscroll of fld "Structured" to the Cscroll of fld "Structured"
      else
         -- check regularly to see if time to search
         put fld "Find delay" of stack "settings" into tFindDelay
         send "do_live_structure_prelims" to me in tFindDelay seconds
      end if
      unlock screen
   end do_live_structure_prelims
   
   on extract_prelims
      put empty into tIgnore
      put 1 into tExtractStart
      put empty into tExtractEnd
      --      grab all text down to \maketitle
      get matchchunk(fld "Main text", \
            "(\\maketitle)", \
            tExtractEnd, \
            tIgnore)
      -- tExtractEnd is end of \maketitle
      set the cExtractStart of fld "Main text" to tExtractStart
      set the cExtractEnd of fld "Main text" to tExtractEnd
      put char tExtractStart to tExtractEnd of fld "Main text" into tText
      --   put empty into char tExtractStart to tExtractEnd of fld "Main Text"
      --      put tText into fld "Structured"
      put empty into tStart; put empty into tEnd
      -- get the class file
      -- ensure comments removed first:
      put _remove_comments(tText) into tNoComments
      get matchchunk(tNoComments, \
            "(?s)\\documentclass\s*(?:\[[^\[\]]*\])?\s*{(.+?)}", \
            tStart, \
            tEnd \
            )
      put char tStart to tEnd of tNoComments into tClassFile
      set the itemdelimiter to "/"
      -- e.g. folder/jfm > jfm
      put item -1 of tClassFile into tClassFile
      set the cClassFile of group "Structuring" to tClassFile
      --      if the hilite of btn "view diacritics" is true then
      --         put convert_tex_to_diacritics(tText) into tText
      --      end if
      put tText into fld "Unstructured"
      show_structuring
   end extract_prelims
   
   
   on structure_prelims
      put empty into fld "Structured"
      put the cClassFile of group "Structuring" into tClassFile
      put fld "Unstructured" into tText
      put _preliminary_clean_up_prelims(tText) into tText
      style_prelims tClassFile, tText
   end structure_prelims
   
   on style_prelims pClassFile, pText
      put convert_tex_to_diacritics(pText) into pText
      switch pClassFile
         case "jfm"
            _style_jfm_prelims pText
            break
         case "jpp"
            -- PLA
            _style_jfm_prelims pText
            break
         case "cmsart"
            -- BCM, CJM
            _style_cmsart_prelims pText
            break
      end switch
   end style_prelims
   
   function _preliminary_clean_up_prelims pText
      put _remove_comments(pText) into pText
      put _multiple_spaces_to_single_space(pText) into pText
      --   put _replace_tilde_return_and_spaces_to_space(pText) into pText
      
      --   put convert_tex_to_diacritics(pText) into pText
      --   put _remove_empty_braces_end_of_line(pText) into pText
      put _remove_returns_around_option(pText) into pText
      put _move_author_address_etc_to_new_line(pText) into pText
      put _remove_leading_trailing_spaces_each_line(pText) into pText
      put _remove_return_after_open_brace(pText) into pText
      put _remove_slash_break(pText) into pText
      --  ",\\" and "\\" > ,
      get sunnYreplace(pText, ",?\s*(\\\\)", ", ", pText)
      put _convert_slash_space_to_space(pText) into pText
      return pText
   end _preliminary_clean_up_prelims
   
   function _remove_slash_break pText
      put replacetext(pText, "(\\break\s+)", return) into pText
      return pText
   end _remove_slash_break
   
   function _remove_empty_braces_end_of_line pText
      put replacetext(pText, "(?s)({}\n)", return) into pText
      return pText
   end _remove_empty_braces_end_of_line
   
   function _remove_return_after_open_brace pText
      put replacetext(pText, "(?s)({\n)", "{") into pText
      return pText
   end _remove_return_after_open_brace
   
   function _convert_slash_space_to_space pText
      -- ensure previous char is not \
      put replacetext(pText, "((?s)(?<!\\)\\\s+)", space) into pText
      return pText
   end _convert_slash_space_to_space
   
   function _remove_leading_trailing_spaces pText
      put replacetext(pText, "^\s+", "") into pText
      put replacetext(pText, "\s+$", "") into pText
      return pText
   end _remove_leading_trailing_spaces
   
   on _style_cmsart_prelims pText
      put true into gDoNotAbbreviate -- temp hack
      put pText into tAuthorAffs
      put _move_author_address_etc_to_new_line(tAuthorAffs) into tAuthorAffs
      put _clean_up_spaces_cmsart(tAuthorAffs) into tAuthorAffs
      --   put _collect_author_aff_components_cmsart(tAuthorAffs) into tAuthorAffs
      --
      put _convert_address_plus(tAuthorAffs) into tAuthorAffs
      --   put _move_author_address_etc_to_new_line(tAuthorAffs) into tAuthorAffs
      put _style_each_item_cmsart(tAuthorAffs) into tAuthorAffs
      put _change_gn_sn_to_gname_sname(tAuthorAffs) into tAuthorAffs
      --   put _reorder_author_affs(tAuthorAffs) into tAuthorAffs
      put tAuthorAffs into fld "structured"
      final_clean_up_prelims
      --   put _style_each_
      put false into gDoNotAbbreviate
   end _style_cmsart_prelims
   
   function _remove_returns_around_option pText
      put replacetext(pText, "(?sx)(?<=[A-Za-z])((\n)\[)", "[") into pText
      put replacetext(pText, "(?sx)(?<=[A-Za-z])((\n){)", "{") into pText
      put replacetext(pText, "((?sx)\]\n{)", "]{") into pText
      return pText
   end _remove_returns_around_option
   
   function _reorder_author_affs pText
      put return after pText -- to make regexp work
      put pText into tAuthors
      -- remove all \aff
      put replacetext(tAuthors, "(?sx)\\aff\[.+?\n\n", return & return) into tAuthors
      put pText into tAffs
      -- remove all \author
      put replacetext(tAffs, "(?sx)\\author\[.+?\n\n", return & return) into tAffs
      put tAuthors & tAffs into tResult
      put replacetext(tResult, "\n\n+", return & return) into tResult
      return tResult
   end _reorder_author_affs
   
   function _change_gn_sn_to_gname_sname pAuthors
      get sunnYreplace(pAuthors, "\\sn{", "\\sname{", pAuthors)
      get sunnYreplace(pAuthors, "\\gn{", "\\gname{", pAuthors)
      return pAuthors
   end _change_gn_sn_to_gname_sname
   
   function _renumber_author_affs pText
      -- Affs
      put 0 into tCount
      put empty into tStart; put empty into tEnd
      repeat until matchchunk(pText, "(\\aff\[.*?\])", tStart, tEnd) is false
         put tCount + 1 into tCount
         put "\aff•[" & tCount & "]•" into char tStart to tEnd of pText
      end repeat
      replace "•" with "" in pText
      -- Authors
      put empty into tResult
      put empty into tStart; put empty into tEnd
      put replacetext(pText, "(\\author\[.*?\])", "\author[]") into pText
      -- find author group: \author.... \aff ... followed by \author or end of file
      repeat until matchchunk(pText, "((?sx)\\author.+?\\aff\[.+?(?=\\author|$))", \
            tStart, tEnd) is false
         put char tStart to tEnd of pText into tAuthorGroup
         put empty into char tStart to tEnd of pText
         put tAuthorGroup into tTemp
         filter lines of tTemp with regex pattern "\\aff\[.+\]"
         replace "\aff[" with "" in tTemp
         replace "]{" with comma in tTemp
         replace return with "" in tTemp
         delete last char of tTemp
         replace "\author[]" with "\author[" & tTemp & "]" in tAuthorGroup
         put return&return& tAuthorGroup after tResult
      end repeat
      return tResult
   end _renumber_author_affs
   
   function _convert_address_plus pText
      put replacetext(pText,  \
            "((?sx)\s+\\addressplus \s+)",  \
            "}" & return & return & "\address{") into pText
      return pText
   end _convert_address_plus
   
   function _extract_packages_and_definitions pText
      put empty into tPackageList
      put empty into tDeclareList
      put empty into tNewcommandList
      put fld "Main text" into tMaintext
      -- extract main text (after \maketitle)
      put _remove_comments(tMaintext) into tMaintext
      --   put replacetext(tMaintext, "(?s)(.+\\maketitle)", "") into tMaintext
      put offset("\maketitle", tMaintext) into tOffset
      put empty into char 1 to tOffset of tMaintext
      put sTagsInPrelims into tTagList
      replace return with "|" in tTagList
      put "(?sx)(\\(?:" \
            & tTagList &  \
            ")(?:\s*\[[^\]]*\])?{.+?[}\]]\n\n)" into tSearch
      put empty into tStart; put empty into tEnd
      repeat while matchChunk(pText, tSearch, tStart, tEnd) is true
         put char tStart to tEnd of pText into tCurrentChunk
         put empty into char tStart to tEnd of pText
         switch trueword 1 of tCurrentChunk
            case "usepackage"
               put tCurrentChunk after tPackageList
               break
            case "usetikzlibrary"
               put tCurrentChunk after tPackageList
               break
            case "newcommand"
               if _is_used_in_doc(tCurrentChunk, tMaintext) then
                  put tCurrentChunk after tNewcommandList
               end if
               break
            case "let"
               if _is_used_in_doc(tCurrentChunk) then
                  put tCurrentChunk after tNewcommandList
               end if
               break
            case "def"
               if _is_used_in_doc(tCurrentChunk) then
                  put tCurrentChunk after tNewcommandList
               end if
               break
            case "DeclareMathOperator"
               put tCurrentChunk after tDeclareList
               break
            case "newtheorem"
               put tCurrentChunk after tNewcommandList
               break
            case "newcounter"
               put tCurrentChunk after tNewcommandList
               break
            case "numberwithin"
               put tCurrentChunk after tDeclareList
               break
         end switch
      end repeat
      put _multiple_returns_to_single_return(tNewcommandList) into tNewcommandList
      put _multiple_returns_to_single_return(tDeclareList) into tDeclareList
      put _multiple_returns_to_single_return(tPackageList) into tPackageList
      put tPackageList &return&return & tDeclareList &return&return & tNewcommandList into tResult
      return tResult
   end _extract_packages_and_definitions
   
   function _is_used_in_doc pChunk, pMainText
      put _extract_from_first_braces(pChunk) into pChunk
      put force_to_regexp(pChunk) into pChunk
      put "(" & pChunk &  "\b)" into tSearch
      if matchchunk(pMainText, tSearch) then
         return true
      end if
   end _is_used_in_doc
   
function _style_each_item_cmsart pText
   put sHeadersA["cmsart"]["header"] into tHeader
   put empty into tNewcommandList
   put _extract_packages_and_definitions(pText) into tPackagesAndDefinitions
   put sTagsInPrelims into tTagList
   replace return with "|" in tTagList
   put "(?sx)(\\(?:" \
         & tTagList &  \
         ")(?:\s*\[[^\]]*\])?{.+?}\n\n)" into tSearch
   put empty into tStart; put empty into tEnd
   repeat while matchChunk(pText, tSearch, tStart, tEnd) is true
      put char tStart to tEnd of pText into tCurrentChunk
      put empty into char tStart to tEnd of pText
      switch trueword 1 of tCurrentChunk
         case "author"
            get matchtext(tCurrentChunk, "\[(.+?)\]", tOption)
            get matchtext(tCurrentChunk, "{(.+)}", tOneAuthor)
            put _replace_tilde_return_and_spaces_to_space(tOneAuthor) into tOneAuthor
            put prelims_given_name_first(tOneAuthor, space) into tOneAuthor
            put return & "\author[" & tOption & "]{"  & return &  \
                  tOneAuthor & return & "}" & return & return into tOneAuthor
            put tOneAuthor & return after tAuthorBits
            break
         case "address"
            put empty into tStart; put empty into tEnd
            get matchChunk(tCurrentChunk, "\[(.*?)\]", tStart, tEnd)
            put char tStart to tEnd of tCurrentChunk into tOption
            if tOption is false then put empty into tOption
            get matchtext(tCurrentChunk, "(?sx){(.+)}", tAddress)
            put _split_address_lines(tAddress) into tAddress
            put _tag_address_lines(tAddress) into tAddress
            put _final_clean_Affs(tAddress) into tAddress
            put "\aff[" & tOption & "]{" & return & \
                  tAddress into tAddress
            put tAddress & return after tAuthorBits
            break
         case "email"
            put tCurrentChunk & return & return after tAuthorBits
            break
         case "title"
            put _extract_option(tCurrentChunk) into tTitleOption
            put _extract_from_braces(tCurrentChunk) into tTitle
            put _remove_full_point_from_end_if_present(tTitle) into tTitle
            if tTitleOption is empty then put tTitle into tTitleOption
            put "\title{" & tTitle & "}" into tTheTitle
            put "\righttitle{" & tTitleOption & "}"  into tRigthtTitle
            break
         case "thanks"
            put _extract_from_braces(tCurrentChunk) into tThanks
            replace return with space in tThanks
            put "\protect\tfootnote{" & tThanks & "}"  into tFootnote
            break
         case "urladdr"
            put _extract_from_braces(tCurrentChunk) into urladdr
            put "\url{" & urladdr & "}" into urladdr
            put urladdr & return  after tAuthorbits
            break
         case "pagecount"
            set the itemdelimiter to "{"
            put the last item of tCurrentChunk into tPages
            set the itemdelimiter to "}"
            put the first item of tPages into tPages
            break
         case "received"
            put "%" & tCurrentChunk into tReceived
            break
         case "revised"
            put "%" & tCurrentChunk into tRevised
            break
         case "copyeditor"
            put _extract_from_braces(tCurrentChunk) into tCopyeditor
            break
      end switch
   end repeat
   -- put all together
   put empty into tResult
   -- put in header from google sheet
   put  tHeader & return & return after tResult
   -- fill in details for header template from Google Sheets
   replace "\jnlPage{1}{}" with "\jnlPage{1}{" & tPages & "}" in tResult
   replace "\received{}" with tReceived in tResult
   replace "\revised{}" with tRevised in tResult
   replace "\copyeditor{}" with "\copyeditor{" & tCopyeditor & "}" in tResult
   -- packages etc -----
   put tPackagesAndDefinitions & return&return after tResult
   put "\end{PDFdef} %--------------- \end{PDFdef} ------------------" & return & return after tResult
   -- title ----
   put tTheTitle & return after tResult
   put tFootnote & return & return after tResult
   put tRigthtTitle & return&return after tResult
   put _extract_lefttitle_from_authorbits_cmsart(tAuthorbits) into tlefttitle
   put tlefttitle after tResult
   put _renumber_author_affs(tAuthorBits) into tAuthorBits
   put tAuthorBits after tResult
   put the label of btn "Journal" into tJournal
   replace "\documentclass[journal" with "\documentclass[" & tolower(tJournal) in tResult
   -- Attach email to previous address:
   put replacetext(tResult, "\n+\\email", return & "\email") into tResult
   put replacetext(tResult, "\n+\\url", return & "\url") into tResult
   -- put closing brace after address/email:
   put return & return after tResult
   get sunnyreplace(tResult, "(?sx)(\\aff.+?)\n\n", "\1\n}\n\n", tResult)
   --
   return tResult
end _style_each_item_cmsart
   
   function _remove_full_point_from_end_if_present pText
      put replacetext(pText, "(\s*\.\s*)?$", "") into pText
      return pText
   end _remove_full_point_from_end_if_present
   
   function _extract_lefttitle_from_authorbits_cmsart pText
      put empty into tResult
      repeat for each line L in pText
         if L begins with "\sn" or L  begins with "\gn" then
            put L & return after tResult
         end if
      end repeat
      put empty into char -1 of tResult
      put the label of btn "journal" into tJournal
      put _running_head_authors(tResult, tJournal) into tRunning
   end _extract_lefttitle_from_authorbits_cmsart
   
   function _convert_to_month_day_year tDate
      -- 2018-03-19 > March 19, 2018
      set the itemdelimiter to "-"
      put item 1 of tDate into tYear
      put _convert_month_no_to_month(item 2 of tDate) into tMonth
      put item 3 of tDate into tDay
      return tMonth && tDay & "," && tYear
   end _convert_to_month_day_year
   
   function _convert_month_no_to_month pNumber
      put "January,February,March,April,May,June,July,August,September," into tMonthsA
      put "October,November,December" after tMonthsA
      split tMonthsA by comma
      if char 1 of pNumber is "0" then delete char 1 of pNumber
      return tMonthsA[pNumber]
   end _convert_month_no_to_month
   
   function _extract_option pText
      -- e.g. \title[option]{The title}
      put empty into tStart; put empty into tEnd
      if matchchunk(pText, "(?s)\\title\[(.*?)\].+",tStart, tEnd) then
         return char tStart to tEnd of pText
      else
         return empty
      end if
   end _extract_option
   
   function _extract_from_braces pText
      -- e.g. \title[option]{The title}
      put empty into tStart; put empty into tEnd
      -- long match, can contain braces
      get matchchunk(pText, "(?s)\\[A-Za-z].*?{(.+)}", tStart, tEnd)
      put char tStart to tEnd of pText into tResult
      return tResult
   end _extract_from_braces
   
   function _extract_from_first_braces pText
      -- e.g. \title[option]{The title}
      put empty into tStart; put empty into tEnd
      get matchchunk(pText, "(?s)\\[A-Za-z].*?{([^{}]+?)}", tStart, tEnd)
      put char tStart to tEnd of pText into tResult
      return tResult
   end _extract_from_first_braces
   
   function _clean_up_spaces_cmsart pText
      get sunnYreplace(pText, "\\author\s*(\[[^\]]+?\])\s*", "\\author\1", pText)
      get sunnYreplace(pText, "\\address\s*(\[[^\]]+?\])?\s*{", "\\address\1{", pText)
      return pText
   end _clean_up_spaces_cmsart
   
   function _collect_author_aff_components_cmsart pText
      --grab only lines of interest
      put "(?sx)(\\(?:pagecount|received|revised|author|title|address|email|thanks|keywords|urladdr|amsclassification)(?:\[[^\]]*\])?{.+?}(?=\n))" into tSearch
      get sunnYreplace(pText, tSearch, "••\1\n•••", pText)
      put "••" after pText
      put "•••" before pText
      get sunnYreplace(pText, "(?s)•••.*?••", "\n", pText)
      return pText
   end _collect_author_aff_components_cmsart
   
function _move_author_address_etc_to_new_line pText
   -- ensure blank line above each tag
   put _remove_leading_trailing_spaces_each_line(pText) into pText
   put Tags_in_prelims into tTagList
   replace return with "|" in tTagList
   put "(?sx)(\\(?:" \
         & tTagList &  \
         ")(?:\s*\[[^\]]*\])?{.+?})(?=\n\n)" into tTags
   put "((?<!\n\n)" & tTags & ")" into tTags
   put empty into tStart; put empty into tEnd
   repeat until matchchunk(pText, tTags, tStart, tEnd) is false
      put return&return before char tStart of pText
   end repeat
   -- move \def\... \let\... to new line:
   repeat until matchchunk(pText, "(?<!\n\n)(\\let|\\def)", tStart, tEnd) is false
      put return&return before char tStart of pText
   end repeat
   return pText
end _move_author_address_etc_to_new_line
   
   on _style_jfm_prelims pText
      ------------------------------- Authors
      put true into gDoNotAbbreviate -- temp hack
      put pText into tAuthors
      put empty into tStart; put empty into tEnd
      -- grab authors:
      get matchchunk(tAuthors, \
            "(?s)\\author\s*(?:\[[^\[\]]+?\])?\s*%?\s*{\s*(.+?)\s*}(?=\s+\\affiliation)", \
            tStart, \
            tEnd \
            )
      put char tStart to tEnd of tAuthors into tAuthors
      
      -- \aff{} > \aff{1}
      put replacetext(tAuthors, "\\aff\s*{\s*}", "\aff{1}") into tAuthors
      -- $^1$ > \aff{1}
      put _convert_superscript_to_aff(tAuthors) into tAuthors
      put _misc_clean_up_authors(tAuthors) into tAuthors
      -- \aff{1,2,3} > •1•2•3
      repeat while matchChunk(tAuthors, "(?s)\\aff\s*{[^{}]*,[^{}]*}",tStart, tEnd)
         get sunnYreplace(tAuthors, "(?s)(\\aff\s*{[^{}]*),([^{}]*})", "\1•\2", tAuthors)
      end repeat
      -- \aff{1•2•3} > •1•2•3•
      get sunnYreplace(tAuthors, "(?s)\\aff\s*{\s*(.+?)\s*}", "•\1•", tAuthors)
      -- convert \thanks{Email address for correspondence: ... >> \corresp{\email{...
      get sunnYreplace(tAuthors, \
            "(?s)\\thanks{Email\s+address\s+for\s+correspondence:\s*([^}]+)", \
            "\\corresp{\\email{\1}", tAuthors)
      -- remove commas in \email{...}
      repeat while matchChunk(tAuthors, "(?s)\\email\s*{[^{}]*,[^{}]*}",tStart, tEnd)
         get sunnYreplace(tAuthors, "(?s)(\\email\s*{[^{}]*),([^{}]*})", "\1\2", tAuthors)
      end repeat
      -- ", \and" > ","    "\and" > ","   "and" > "," (whole word "and")
      get sunnYreplace(tAuthors, "((?s),?\s*(\\)?\band\b)", ", ", tAuthors)
      get sunnYreplace(tAuthors, "((?s),?\s*(\\)?\&)", ", ", tAuthors)
      -- sometimes author puts Smith,\aff{...} so remove
      put _remove_comma_before_bullet(tAuthors) into tAuthors
      put _convert_return_to_space(tAuthors) into tAuthors
      -- put each author on new line
      put replacetext(tAuthors, "\s*,\s*", return) into tAuthors
      get sunnYreplace(tAuthors, "•(\d)\s+(\d)•", "•\1•\2•", tAuthors)
      put remove_empty_lines(tAuthors) into tAuthors
      --   put _remove_blanks_at_start(tAuthors) into tAuthors
      --   put _remove_blanks_at_end(tAuthors) into tAuthors
      -- remove space before \corresp
      put replacetext(tAuthors, "\s*\\corresp", "\corresp") into tAuthors
      if offset("\corresp", tAuthors) is 0 then
         put "\corresp{\email{@@@@@@@@@@@@@@}}" after line 1 of tAuthors
      end if
      if "•" is not in tAuthors then -- no \aff{}
         put _add_aff_to_authors(tAuthors) into tAuthors
      end if
      put space into tDelimiter
      repeat with i = 1 to the number of lines of tAuthors
         put line i of tAuthors into tLine
         put _replace_tilde_return_and_spaces_to_space(tLine) into tLine
         put offset("•", tLine) into tOffset
         -- extract name to clean up
         put char 1 to tOffset-1 of tLine into tName
         put prelims_given_name_first(tName, tDelimiter) into tName
         replace return with "" in tName
         -- put name back in tAuthors
         put tName into char 1 to tOffset-1 of tLine
         get sunnYreplace(tLine, "(.+?)•(.+)•([^•]*)", "\author[\2]\1\3", tLine)
         put tLine into line i of tAuthors
      end repeat
      put _running_head_authors(tAuthors, jfm) into tRunning
      put true into gDoNotAbbreviate -- hack
      -- put on separate lines
      get sunnYreplace(tAuthors, "(\\author.+)(\\gn.+)(\\sn.+)", "\1\n\2\n\3\n", tAuthors)
      put return after tAuthors
      put _final_clean_Authors_jfm_prelims(tAuthors) into tAuthors
      replace "•" with "," in tAuthors -- replace comma in \aff
      replace "" with "," in tAuthors -- replace comma in emails
      put false into gDoNotAbbreviate -- hack
      ----------------------------- title, shorttitle -----------------------------
      put empty into tStart; put empty into tEnd
      -- grab \shorttitle{...}
      get matchchunk(pText, "(?sx)\\shorttitle{(.+?)}\n\n", tStart, tEnd)
      put char tStart to tEnd of pText into tRightTitle
      -- e.g. \title[short title]{Full title.} -- remove dot if present
      get matchchunk(pText, "(?sx)\\title(?:\[.*?\])?{(.+?)\.?}\n\n", tStart, tEnd)
      put char tStart to tEnd of pText into tTitle
      put _convert_return_to_space(tTitle) into tTitle
      -- grab shorttitle from \title[...]{title}
      get matchchunk(pText, "(?sx)\\title(?:\[(.*?)\])?{.+?\.?}\n\n", tStart, tEnd)
      -- set righttitle only if still empty
      --Divya I set this condition. ensure you understand what this section does
      if tRightTitle is empty then
         put char tStart to tEnd of pText into tRightTitle
      end if
      -- set righttitle to title if still empty
      if tRightTitle is empty then put tTitle into tRightTitle
      ----------------------------- Affiliations ---------------------------
      put pText into tAffs
      put _remove_comments(tAffs) into tAffs
      put empty into tStart
      put empty into tEnd
      -- grab text in \affiliation{...}\r\r (must have two returns after)
      get matchchunk(tAffs, \
            "(?s)\\affiliation\s*{\s*(.+?)\s*} *\n *\n", \
            tStart, \
            tEnd \
            )
      put char tStart to tEnd of tAffs into tAffs
      --   put _replace_tilde_return_and_spaces_to_space(tAffs) into tAffs
      
      -- \aff{} > \aff{1}
      put replacetext(tAffs, "\\aff\s*{\s*}", "\aff{1}") into tAffs
      -- $^1$, $^a$ > \aff{...}
      put _convert_superscript_to_aff(tAffs) into tAffs
      --   put _remove_all_blanks(tAffs) into tAffs
      if char 1 to 5 of tAffs is not "\aff{" then put "\aff{1}" before tAffs
      put replacetext(tAffs, "(,?\s*\[\\affilskip\])", "") into tAffs
      -- \\ with space or return after
      put _double_slash_to_space(tAffs) into tAffs
      
      put _convert_return_to_space(tAffs) into tAffs
      -- put each \aff on separate line
      put replacetext(tAffs, "\s+\\aff{", return & "\aff{") into tAffs
      -- to keep comma separated address lines together, remove space after comma:
      put _split_address_lines(tAffs) into tAffs
      put _space_after_commas(tAffs) into tAffs
      
      -- \aff{ } > \aff[ ]
      get sunnYreplace(tAffs, "\\aff{(\d+)}", "\n\\aff[\1]\n", tAffs)
      -- Remove return at start
      put empty into char 1 of tAffs
      put _tag_address_lines(tAffs) into tAffs
      put _final_clean_Affs(tAffs) into tAffs
      get sunnYreplace(tAffs, "(?s)(\\aff\[.+?)(?=\n\n)", "\1\n}", tAffs)
      
      -- put the elements together into "structured"
      put empty into tResult
      put "\title{" & tTitle & "}" & return after tResult
      put "\righttitle{" & tRightTitle & "}" & return after tResult
      put  tRunning & return & return after tResult
      put tAuthors after tResult
      put return & return & tAffs after tResult
      -- remove [1] for single author and aff
      
      if matchtext(tResult, "(?s)\\author\[.+\\author\[") is false and \
            matchtext(tResult, "(?s)\\aff\[.+\\aff\[") is false then
         put replacetext(tResult, "\\author.+", "\author{") into tResult
         put replacetext(tResult, "\\aff.+", "\aff{") into tResult
      end if
      put tResult into fld "Structured"
      --
      final_clean_up_prelims
   end _style_jfm_prelims
   
   function _misc_clean_up_authors pText
      -- remove \ns
      put replacetext(pText, "(\\ns)(?![A-Za-z])", "") into pText
      -- remove \ls
      put replacetext(pText, "(\\ls)(?![A-Za-z])", "") into pText
      -- \and{} > \and
      put replacetext(pText, "\\and\s*{}", "\and") into pText
      return pText
   end _misc_clean_up_authors
   
   function _remove_comma_before_bullet pText
      put replacetext(pText, "(,•)", "•") into pText
      return pText
   end _remove_comma_before_bullet
   
   on final_clean_up_prelims
      put fld "structured" into tPrelims
      --   put remove_spaces_inside_curly_braces (tPrelims) into tPrelims
      --   put _multiple_spaces_to_single_space(tPrelims) into tPrelims
      put _multiple_returns_to_two_returns(tPrelims) into tPrelims
      if the hilite of btn "view diacritics" is false then
         put convert_diacritics_to_tex(tPrelims) into tPrelims
      end if
      put color_all_tags_in_refs(tPrelims) into tHTML
      set the htmltext of fld "structured" to tHTML
   end final_clean_up_prelims
   
   function _et_al_to_etal_in_option pText
      if matchchunk(pText, "\\bibitem\[.+?(et\s*al\.?).*?\]", tStart, tEnd) then
         put "\etal" into char tStart to tEnd of pText
      end if
      return pText
   end _et_al_to_etal_in_option
   
   function _space_after_commas pText
      put replacetext(pText, ",(?=[^ ])", ", ") into pText
      return pText
   end _space_after_commas
   
   function _split_address_lines pAddress
      -- Split address into lines (but do not convert "\,")
      -- note must be space or return after comma
      put replacetext (pAddress, "(?<!\\),\s+", return) into pAddress
      return pAddress
   end _split_address_lines
   
   
   function _final_clean_Authors_jfm_prelims pAuthors
      get sunnYreplace(pAuthors, "(\\author.+)", "\1{", pAuthors)
      put _change_gn_sn_to_gname_sname(pAuthors) into pAuthors
      get sunnYreplace(pAuthors, "(\\sname.+)",  \
            "\1\n}",  \
            pAuthors)
      put empty into char -2 to -1 of pAuthors
      return pAuthors
   end _final_clean_Authors_jfm_prelims
   
   function _final_clean_Affs pAffs
      get sunnYreplace(pAffs, "(\\aff.+)", "\1{", pAffs)
      return pAffs
   end _final_clean_Affs
   
   function _running_head_authors pAuthors, pJournal
      put pAuthors into tRunning
      put _gn_sn_to_table(pAuthors) into tRunning
      put false into gDoNotAbbreviate
      repeat with i = 1 to the number of lines of tRunning
         set the Itemdelimiter to tab
         put item 1 of line i of tRunning into tGname
         put abbreviate_given_names(tGname) into tGname
         put insert_dot_after_given_names(tGname) into tGname
         put tGname into item 1 of line i of tRunning
      end repeat
      put the number of lines of tRunning into tAuthorCount
      switch
         case pJournal is "jfm" or pJournal is "pla"
            switch
               case tAuthorCount = 1
                  put line 1 of tRunning into tRunning
                  break
               case tAuthorCount > 1 AND tAuthorCount < 7
                  put line 1 to tAuthorCount of tRunning into tRunning
                  break
               case tAuthorCount > 6
                  put " and others" into line 2 to -1 of tRunning
                  break
            end switch
            if tAuthorCount > 1 and tAuthorCount <7 then
               repeat with i = 1 to the number of lines of tRunning - 2
                  put comma after line i of tRunning
               end repeat
               put " and" after line -2 of tRunning
            end if
            break
         case pJournal is "cjm" or pJournal is "bcm"
            switch
               case tAuthorCount = 1
                  put line 1 of tRunning into tRunning
                  break
               case tAuthorCount > 1
                  put line 1 to tAuthorCount of tRunning into tRunning
                  break
            end switch
            if tAuthorCount = 2 then
               put " and" after line 1 of tRunning
            end if
            if tAuthorCount > 2 then
               repeat with i = 1 to the number of lines of tRunning - 1
                  put comma after line i of tRunning
               end repeat
               put " and" after line -2 of tRunning
            end if
            break
      end switch
      put _remove_leading_trailing_spaces(tRunning) into tRunning
      -- replace multiple spaces and returns to single space
      put replacetext(tRunning, "(?s)\s+", " ") into tRunning
      put "\lefttitle{" & tRunning & "}" into tRunning
      return tRunning
   end _running_head_authors
   
   function _gn_sn_to_table pAuthors
      -- move \gn and \sn to same line:
      replace return & "\sn" with "\sn" in pAuthors
      put replacetext(pAuthors, "(\\gname)", "\gn") into pAuthors
      put replacetext(pAuthors, "(\\sname)", "\sn") into pAuthors
      put replacetext(pAuthors, "(.+)\\gn{", "\gn{") into pAuthors
      put replacetext(pAuthors, "(\\corresp.+)", "") into pAuthors
      put replacetext(pAuthors, "\\gn{", "") into pAuthors
      put replacetext(pAuthors, "}\\sn{", tab) into pAuthors
      put replacetext(pAuthors, "}\n",  return) into pAuthors
      put replacetext(pAuthors, "}$", "") into pAuthors
      return pAuthors
   end _gn_sn_to_table
   
   function _table_to_gn_sn pAuthors
      get sunnYreplace(pAuthors, "(.+)\t(.+)", "\\gn{\1}\\sn{\2}", pAuthors)
      return pAuthors
   end _table_to_gn_sn
   
   function _convert_superscript_to_aff pText
      -- $^{ 4 }$ > \aff{4}
      get sunnYreplace(pText, "\$\s*\^\s*{\s*(.+?)\s*}\s*\$", "\aff{\1}", pText)
      -- $^ 4 $ > \aff{4}
      get sunnYreplace(pText, "\$\s*\^\s*(.+?)\s*\$", "\aff{\1}", pText)
      put replacetext(pText, "\\aff{a}", "\aff{1}") into pText
      put replacetext(pText, "\\aff{b}", "\aff{2}") into pText
      put replacetext(pText, "\\aff{c}", "\aff{3}") into pText
      put replacetext(pText, "\\aff{d}", "\aff{4}") into pText
      put replacetext(pText, "\\aff{e}", "\aff{5}") into pText
      put replacetext(pText, "\\aff{f}", "\aff{6}") into pText
      put replacetext(pText, "\\aff{g}", "\aff{7}") into pText
      return pText
   end _convert_superscript_to_aff
   
   function _add_aff_to_authors pAuthors
      repeat with i = 1 to the number of lines of pAuthors
         put line i of pAuthors into tAuthor
         if "\corresp" is in tAuthor then
            replace "\corresp" with "•1•\corresp" in tAuthor
            put tAuthor into line i of pAuthors
         else
            put "•1•" after line i of pAuthors
         end if
      end repeat
      return pAuthors
   end _add_aff_to_authors
   
   function _tag_address_lines pAffs
      put return & return after pAffs
      repeat with i = 1 to the number of lines of pAffs
         put line i of pAffs into tLine
         if tLine begins with "\aff" or tLine is empty then next repeat
         --      put force_to_regexp(tLine) into tString
         put sCountries into tCountries
         repeat for each line tCountry in tCountries
            -- check line matches a city (removing full point at end)
            put "(?i)(^" & tCountry & "\.?$)" into tSearch
            if matchchunk(tLine, tSearch) then
               put "\cnty{" & tCountry & "}" into line i of pAffs
               -- take from list so upper/lower is correct
               exit repeat
            else
               put _remove_leading_trailing_spaces(tLine) into tLine
               put "\addr{" & tLine & "}," into line i of pAffs
            end if
         end repeat
      end repeat
      put replacetext(pAffs, "\\addr{\s*II\s+", "\inst{") into pAffs
      -- remove final comma:
      put replacetext(pAffs, "(?s)(,\n\n)", return & return) into pAffs
      return pAffs
   end _tag_address_lines pAffs
   
   on do_live_structure_all_refs
      ensure_locked
      put the milliseconds into tTimeNow
      if the cText_has_changed of fld "Unstructured" is false then
         -- no key pressed since handler was last called
         exit do_live_structure_all_refs
      end if
      --
      put (fld "Type delay" of stack "settings") * 1000 into tTypeDelay
      if (tTimeNow - the cWhen_text_changed of fld "Unstructured") \
            < tTypeDelay then
         put fld "Find delay" of stack "settings" into tFindDelay
         send "do_live_structure_all_refs" to me in tFindDelay seconds
         exit do_live_structure_all_refs
      end if
      --
      set the Cscroll of fld "Unstructured" to the vscroll of fld "Unstructured"
      set the Cscroll of fld "Structured" to the vscroll of fld "Structured"
      put the CselectedChunk of fld "Unstructured" into tFocusedChunk
      put word 4 of tFocusedChunk into tChar -- Offset of last char selected
      if tChar is empty then
         -- no selection
         put 1 into tChar
      end if
      structure_all_refs
      put extract_key("Unstructured",tChar) into tKey -- e.g. {Smith_1986}
      _color_focused_ref "Unstructured", tKey
      _color_focused_ref "Structured", tKey
      focus fld "Unstructured"
      select tFocusedChunk
      set the cText_has_changed of fld "Unstructured" to false
      set the vscroll of fld "Unstructured" to the Cscroll of fld "Unstructured"
      set the vscroll of fld "Structured" to the Cscroll of fld "Structured"
      -- check regularly to see if time to search
      unlock screen
   end do_live_structure_all_refs
   
   
   on selectionChanged
      
      lock screen
      put the short name of the target into tTarget
      --
      -- Structuring references
      --
      if the short name of the owner of the target is "Structuring" then
         if tTarget is "Unstructured" then
            put "Unstructured" into tThis
            put "Structured" into tOther
         else if tTarget is "Structured" then
            put "Unstructured" into tOther
            put "Structured" into tThis
         end if
         if fld tOther is empty then
            pass selectionChanged
         end if
         put the selectedChunk of the target into tFocusedChunk
         put word 2 of tFocusedChunk into tFrom
         put word 4 of tFocusedChunk into tTo
         if tTo > tFrom then
            pass selectionChanged -- some text is selected
         end if
         switch the cNowProcessing of group "Structuring"
            case "References"
               -- cursor between refs, so blank line
               if char tTo to tFrom of fld tThis is return & return then
                  pass selectionChanged
               end if
               put tTo into tChar
               put extract_key(tTarget,tChar) into tKey
               if the cCurrentKey of fld "Structured" is tKey then
                  pass selectionChanged -- so cursor movement is not slowed down
               end if
               
               set the cCurrentKey of fld "Structured" to tKey
               _color_focused_ref "Unstructured", tKey
               _color_focused_ref "Structured", tKey
               correct_scroll_to_view_item tOther, tKey
               --            correct_scroll_to_view_item tThis, tKey
               focus fld tTarget
               
               break
            case "Prelims"
               if the hilite of btn "sync view" is true then
                  sync_windows tThis, tOther
               end if
               break
         end switch
      end if
      --
      --   Main text
      --
      if the short name of the target is "Main text" then
         put the selectedChunk of fld "Main text" into tCurrentChunk
         put word 2 of tCurrentChunk into tStart
         if _should_replacement_show(tCurrentChunk) then
            _get_start_end_current_chunk tStart
            show_replacement
         else
            hide fld "replacement"
         end if
      end if
      unlock screen
   end selectionChanged
   
   on sync_windows tThis, tOther
      put word 4 of the selectedchunk of fld tThis into tCharCount
      put "(" & char tCharCount to tCharCount of fld tThis & ")" into tSearch
      if matchtext(tSearch, "([A-Za-z])") is false then
         exit sync_windows
      end if
      
      put the number of truewords in char 1 to tCharCount of fld tThis into tCountFromStart
      put trueword tCountFromStart  of fld tThis into tWord
      --   put tWord into msg
      set the backgroundcolor of char 1 to -1 of fld tOther to empty
      put tWord into tString
      -- search for one occurrence:
      put "(?s)(\b" & tString & "\b)" into tSearch1
      -- search for two occurrences:
      put "(?s)(\b" & tString & "\b).+(\b" & tString & "\b)" into tSearch2
      if  matchchunk(fld tOther, tSearch1) is true  \
            AND matchchunk(fld tOther, tSearch2) is false then
         --      put "   YES" after msg
         -- there is a unique match
         get matchchunk(fld tOther, tSearch1, tStart, tEnd)
         set the backgroundcolor of char tStart to tEnd of fld tOther to Pink
         set the cSyncFrom of fld tOther to tStart
         set the cSyncTo of fld tOther to tEnd
         ensure_locked
         correct_scroll_to_view_item tOther, tString
         unlock screen
         focus fld tThis
      else
         set the cSyncFrom of fld tOther to empty
         set the cSyncTo of fld tOther to empty
      end if
   end sync_windows
   
   -- see https://forums.livecode.com/viewtopic.php?f=9&t=33063
   function _clean_up_json_for_unicode pData
      put pData into tData
      ## takes care of "degrees"
      put textDecode(tData, "utf8") into tData
      replace "\\u" with "backslashU" in tData -- if data contains literal "\u" it breaks "numToCodepoint"
      repeat while offset("\u", tData)
         ## isolate hexadecimal number assuming all start with \u and are 4 chars long
         put char tOffset + 2 to tOffset + 5 of tData into tText
         ## put hexadecimal number and convert it to codePoint i.e. a character
         put "0x" before tText
         put numToCodepoint(tText) into tText
         ## replace json-hexadecimal with text representation
         put tText into char tOffset to tOffset + 5 of tData
      end repeat
      replace "backslashU" with "\\u" in tData -- reinsert the hidden literal "\u"
      --   put tData into field "fCleanedRaw"
      return tData
   end _clean_up_json_for_unicode
   
function _get_data_from_Google_Sheet pURL, pSheet
   set the itemdelimiter to "/"
   put item 6 of pURL into tKey
   put "https://docs.google.com/spreadsheets/d/[[tKey]]/gviz/tq?tqx=out:tsv&sheet=[[pSheet]]" into tTSV
   put the merge of tTSV into tURLForTSV
   put url tURLForTSV into tSheetImported
   put _clean_up_json_for_unicode(tSheetImported) into tSheetImported
   
   
   if matchText(tSheetImported, "(?msx) ^ .*? (.table.\:.+) \); $", tJSON) then
      put "{" before tJSON
   else
      answer "Could not find Google Sheet"
      exit _get_data_from_Google_Sheet
   end if
   put jsonImport(tJSON) into tCleanUpDataA
   -- now get only our rows
   put tCleanUpDataA["table"]["rows"] into tCleanUpDataA
   put the number of lines of the keys of tCleanUpDataA into tRows
   put _variables(tCleanUpDataA) into tVariablesA
   --   If sheet has just one column
   if the number of elements of tVariablesA is 1 then
      put empty into tValue
      repeat with row = 1 to tRows
         put tCleanUpDataA[row]["c"][1]["v"] & return after tValue
      end repeat
      put empty into char -1 of tValue
      return tValue
   else
      put _keys(tCleanUpDataA, tRows) into tRealKeysA
      -- make 2D array from table with key as first column
      repeat with col = 1 to the number of elements of tVariablesA
         repeat with row = 2 to the number of elements of tRealKeysA +1
            put tCleanUpDataA[row]["c"][col]["v"] into \
                  tDataA[row][tVariablesA[col]]
         end repeat
      end repeat
   end if
   return tDataA
end _get_data_from_Google_Sheet
   
   
function _variables tArray
   put empty into tVariables
   repeat with col = 1 to 100
      if tArray[1]["c"][col]["v"] is empty then exit repeat
      put tArray[1]["c"][col]["v"] & tab after tVariables
   end repeat
   split tVariables by tab
   return tVariables
end _variables
   
function _keys tArray, pRows
   put empty into tRealKeys
   repeat with row = 2 to pRows -- row 1 is header
      put tArray[row]["c"][1]["v"] & return after tRealKeys
   end repeat
   split tRealKeys by return
   return tRealKeys
end _keys
   
function _should_replacement_show tCurrentChunk
   --      check if the color of letters selected have a replacement to show
   put word 2 of tCurrentChunk into tStart
   put word 4 of tCurrentChunk into tEnd
   --   put tStart && "to" && tEnd && "--" && the textcolor of char tStart to tEnd of fld "main text" \
   --   into fld "coltemp"
   if tEnd >= tStart then
      --      e.g. char 1 to 5
      if the textcolor of char tStart to tEnd of fld "Main text" is in sCleanUpColors then
         return true
      end if
   else
      --      e.g. char 5 to 4
      put the textcolor of char tStart to tStart of fld "Main text" into tAfterCursor
      put the textcolor of char tEnd to tEnd of fld "Main text" into tBeforeCursor
      if tAfterCursor = tBeforeCursor and \
            tBeforeCursor is in sCleanUpColors then
         return true
      end if
   end if
   return false
end _should_replacement_show
   
   on show_replacement
      put replacement() into tReplacement
      if tReplacement is empty or tReplacement is "false" then
         hide fld "replacement"
         exit show_replacement
      end if
      put tReplacement into fld "replacement"
      put the selectedLoc of char gStart +1 to gEnd -1 of fld "Main text" into text_loc
      set the width of fld "replacement" to the formattedwidth of fld "replacement"
      set the left of fld "replacement" to item 1 of text_loc
      set the bottom of fld "replacement" to item 2 of text_loc -5
      show fld "replacement"
      --   focus fld "replacement"
   end show_replacement
   
   function replacement
      put char sSelectionStart to sSelectionEnd of fld "Main text" into tSelection
      put the cSearch of btn sCleanUpItem into tSearch
      put replacetext(tSearch,"(.+•<<•)","") into tSearch
      put replacetext(tSearch,"(•>>•.+)","") into tSearch
      if the cReplace of btn sCleanUpItem is not empty then
         put the cReplace of btn sCleanUpItem into tReplace
         repeat for each line tSearchLine in tSearch
            put empty into tResult
            if sunnYreplace(tSelection, tSearchLine, tReplace, tResult) then
               return tResult
               exit repeat
            end if
         end repeat
      end if
      switch sCleanUpItem
         case "section citation"
            
            break
      end switch
   end replacement
   
   
   on returnInField
      if the short name of the target is "Main text" or \
            the short name of the target is "replacement" then
         if the visible of fld "replacement" is true then
            put_replacement_into_main_file
         else
            write_undo_file
            pass returnInField
         end if
      else
         pass returnInField
      end if
   end returnInField
   
   on put_replacement_into_main_file
      put the number of chars of fld "replacement" into tLength
      put fld "replacement" into char sSelectionStart to sSelectionEnd of fld "Main text"
      put sSelectionStart+tLength-1 into tNewSelectionEnd
      set the textcolor of char sSelectionStart to (tNewSelectionEnd)  \
            of fld "Main text" to sReplacementTextColor
      set the textstyle of char sSelectionStart to (tNewSelectionEnd)  \
            of fld "Main text" to "bold"
      hide fld "replacement"
      select char tNewSelectionEnd + 1 to tNewSelectionEnd of fld "Main text"
      write_undo_file
      get the selectedChunk of fld "Main text"
      put word 4 of it -1 into tCurrentPoint
      select_next_chunk tCurrentPoint
   end put_replacement_into_main_file
   
   on select_next_chunk pHere
      ensure_locked
      put the number of words of char 1 to pHere of fld "Main text" into tWordCursorIsIn
      put the number of words of fld "Main text" into tTotalWords
      put _next_color_in_word(pHere) into tNextInCurrentWord
      if tNextInCurrentWord is not empty then
         _select_and_show_current_chunk tNextInCurrentWord
         exit select_next_chunk
      else
         put tWordCursorIsIn + 1 into tWordCursorIsIn
      end if
      repeat with WordCount = tWordCursorIsIn to tTotalWords
         put the textcolor of word WordCount of fld "Main text" into tColor
         if tColor is empty then
            next repeat
         else
            put _clean_color_offset(WordCount) into tOffsetInWord
            if tOffset is empty then
               next repeat
            end if
            put offset(word WordCount of fld "Main text", fld "Main text") \
                  + tOffsetInWord - 1 \
                  into tOffset
            _get_start_end_current_chunk tOffset
            select char sSelectionStart to sSelectionEnd of fld "Main text"
            send selectionchanged to fld "Main text"
            exit select_next_chunk
         end if
      end repeat
      unlock screen
   end select_next_chunk
   
   on _select_and_show_current_chunk pCursor
      _get_start_end_current_chunk pCursor
      select char sSelectionStart to sSelectionEnd of fld "Main text"
      show_replacement
   end _select_and_show_current_chunk
   
   function _next_color_in_word pCursor
      put pCursor into tCursor
      repeat 10000
         put tCursor + 1 into tCursor
         get char tCursor to tCursor of fld "Main text"
         if it is space or it is return then
            return empty
         end if
         if the textcolor of char tCursor to tCursor of fld "Main text"  \
               is in sCleanUpColors then
            return tCursor
         end if
      end repeat
   end _next_color_in_word
   
   function _clean_color_offset pWordCount
      repeat with i = 1 to the number of chars of word pWordCount of fld "Main text"
         put the textcolor of char i of word pWordCount of fld "Main text" into tColor
         if tColor is in sCleanUpColors then
            return i
            exit repeat
         end if
      end repeat
      return empty
   end _clean_color_offset
   
   --on select_next_chunk pHere
   --   put the number of chars of fld "Main text" into tTotalChars
   --   repeat with i = pHere +1 to tTotalChars
   --      put the textcolor of char i of fld "Main text" into tColor
   --      if tColor is not empty \
   --            and tColor is not mixed \
   --            then
   --         repeat with j = 1 to the number of btns of grp "Items to clean up"
   --            if the cColor of btn j of grp "Items to clean up" is tColor or \
   --                  the cAltColor of btn j of grp "Items to clean up" is tColor then
   --               put the short name of btn j of grp "Items to clean up" into sCleanUpItem
   --               put i into sSelectionStart
   --               put i-1 into sSelectionEnd
   --               show_replacement
   --               exit repeat
   --            end if
   --         end repeat
   --      end if
   --   end repeat
   --end select_next_chunk
   
   
   
   --function replacement pStart
   --   put word 2 of pChunk into tStart
   --   put word 4 of pChunk into tEnd
   --   put char tStart to tEnd of fld "Main text" into the_selection
   --   put the textcolor of char temp_start to temp_end of fld "Main text" into my_color
   --   switch my_color
   --      case citation_text_color -- selection is citation
   --         if citation_style is "$^{mathrm{[1,7-9]}}$" then
   --            delete char 1 to offset("[", the_selection) of the_selection -- e.g. 1, 7-9}}$
   --            delete char offset("]", the_selection) to -1 of the_selection -- e.g. 1, 7-9
   --         end if
   --         set the itemdelimiter to ","
   --         repeat with i = 1 to the number of items of the_selection
   --            put item i of the_selection into the_item
   --            if matchtext(the_item, "([0-9]+)[^0-9]+([0-9]+)", num_start, num_end) then
   --               put num_end - num_start into nums
   --               put num_start into num_added
   --               repeat with j = 1 to nums
   --                  put "••" & num_start + j after num_added
   --               end repeat
   --               put num_added into item i of the_selection
   --            end if
   --         end repeat
   --         put replacetext(the_selection, "••", ",") into the_selection
   --         put replacetext(the_selection, " ", "") into the_selection
   --         put "~\cite{" & the_selection & "}" into the_selection
   --         break
   --      case "Headings"
   --         --
   --   end switch
   --   return the_selection
   --end replacement
   
   on _get_start_end_current_chunk pStart
      put pStart into tStart
      put tStart into tEnd
      -- we know that pStart to pStart has color so need to get rest of chunk
      put the textColor of char tStart to tStart of fld "Main text" into tColor
      if tColor is empty then exit _get_start_end_current_chunk
      repeat 100
         if the textColor of char tStart-1 to tStart-1 of fld "Main text"  \
               is tColor then
            put tStart - 1 into tStart
         else
            exit repeat
         end if
      end repeat
      repeat 100
         if the textColor of char tEnd+1 to tEnd+1 of fld "Main text"  \
               is tColor then
            put tEnd + 1 into tEnd
         else
            exit repeat
         end if
      end repeat
      put tStart into sSelectionStart
      put tEnd into sSelectionEnd
      put item 3 of tColor into tBlue
      repeat with i = 1 to the number of btns of group "Items to clean up"
         if item 3 of the cColor of btn i of group "Items to clean up" is tBlue then
            put the short name of btn i of group "Items to clean up" into sCleanUpItem
            exit repeat
         end if
      end repeat
   end _get_start_end_current_chunk
   
   
   on tabkey
      put the short name of the target into tTarget
      -- Structuring
      if the short name of the owner of the target is "Structuring" then
         if tTarget is "Unstructured" then
            put "Structured" into tOther
         else
            put "Unstructured" into tOther
         end if
         set the cSelected of fld tTarget to the selectedchunk of fld tTarget
         -- test to see which part of document is being processed
         switch the cNowProcessing of group "Structuring"
            case "References"
               put the cCurrentKey of fld "Structured" into tKey
               put empty into tStart; put empty into tEnd
               put "(?s)(.+" & tKey & ")" into tSearch
               get matchchunk(fld tOther, tSearch, tStart, tEnd)
               select char tEnd to tEnd + 1 of fld tOther
               break
            case "Prelims"
               put the cSyncFrom of fld tOther into tFrom
               if tFrom is not empty then
                  put the cSyncTo of fld tOther into tTo
                  set the backgroundColor of char tFrom to tTo of fld tOther to empty
                  select char tFrom to tTo of fld tOther
                  -- synch again from new field
                  if tOther is "unstructured" then
                     put "structured" into tOther
                     put "unstructured" into tThis
                  end if
                  if tOther is "structured" then
                     put "unstructured" into tOther
                     put "structured" into tThis
                  end if
                  sync_windows tThis, tOther
               end if
               break
         end switch
      end if
      -- Replacement
      if tTarget is "Replacement" then
         focus fld "Main text"
      end if
      -- Main text
      if tTarget is "Main text" then
         pass tabkey
         if the visible of fld "Replacement" is true then
            select after fld "Replacement"
            if char -1 of fld "Replacement" is return then
               select char -1 to -2 of fld "Replacement"
            end if
         else
            get the selectedChunk of fld "Main text"
            put word 2 of it into tCurrentPoint
            select_next_chunk tCurrentPoint
            --         if the selectedtext is not empty then
            --            show_replacement
            --         end if
         end if
      end if
   end tabkey
   
   on enterInField
      returnInField
   end enterInField
   
   on read_settings
      put the textcolor of fld "Citation text" of stack "settings" into citation_text_color
      put the textcolor of fld "Heading text" of stack "settings" into heading_text_color
      put the textstyle of fld "Citation text" of stack "settings" into citation_text_style
      put the textstyle of fld "Heading text" of stack "settings" into heading_text_style
      put the backgroundcolor of fld "Original bg" of stack "settings" into original_bg_color
      put the backgroundcolor of fld "Replace bg" of stack "settings" into replace_bg_color
   end read_settings
   
on import_data
   -- multi-colmn sheets:
   _import_latex_headers
   _import_diacritics
   _import_journals
   _import_patterns
   _import_filler_words
   -- single column sheets:
   put _get_data_from_Google_Sheet(gGoogleDataSheet, "Countries") into sCountries
   put _get_data_from_Google_Sheet(gGoogleDataSheet, "Surname_prefixes") into sPrefixes
   put _get_data_from_Google_Sheet(gGoogleDataSheet, "Tags_in_prelims") into sTagsInPrelims
   put _get_data_from_Google_Sheet(gGoogleDataSheet, "Publishers") into sPublishers
end import_data

on    _import_filler_words
   put _get_data_from_Google_Sheet(gGoogleDataSheet, "Journal_filler_words") into sFillerWords
   sort lines of sFillerwords descending by the length of each
end _import_filler_words
   
   on    _import_latex_headers
   put _get_data_from_Google_Sheet(gGoogleDataSheet, "LaTeX_headers") into sHeadersA
end _import_latex_headers
   
   on _import_patterns
      put _get_data_from_Google_Sheet(gGoogleDataSheet, "Patterns") into sPatternsA
      put empty into tPatternOrder
      -- this code is a bit dirty, i.e. going from i = 2 to .... +1
      repeat with i = 2 to the number of elements of sPatternsA + 1
         -- Remove returns and Comments from patterns
         put sPatternsA[i]["Search_pattern"] into tPattern
         put _remove_returns_and_comments(tPattern) into tPattern
         -- get length of each pattern so longer (and more complex) can be run first
         -- so we replace the pattern with identical pattern but no returns or comments:
         put tPattern into sPatternsA[i]["Search_pattern"]
         -- Grab the length, i.e. No of chars of tPattern
         -- this is roughly how complex the pattern is
         put the length of tPattern into tLength
         -- Create new element in sPatternsA to hold the length of each pattern
         put tLength into sPatternsA[i]["Pattern_length"]
         -- Add a new line in sPatternOrder with two numbers: 
         -- Line number then comma, then length of that line
         -- e.g. "20,140" for line 20 that is 140 chars long:
         put i  & "," & sPatternsA[i]["Pattern_length"] & return \
               after sPatternOrder
      end repeat
      -- Remove last return character
   put empty into char -1 of sPatternOrder
   -- Now we can use sPatternOrder to match complex patterns first
   -- Sort by second item – by default itemdelimiter is "," so item two is
   -- length. So after sorting if we have 88, 200 in top line it means
   -- line 88 is longest pattern with 200 chars
   sort lines of sPatternOrder numeric descending by item 2 of each
   -- we no longer need the second item, so remove:
   -- e.g. "88,200" > "88". Later we used sPatternOrder to decide order of matching
   put replacetext(sPatternOrder, "(,.+)", "") into sPatternOrder
end _import_patterns

on _import_journals
      put _get_data_from_Google_Sheet(gGoogleDataSheet, "Journals") into tJournalsA
      put empty into sJournals
      put the keys of tJournalsA into tKeys
      repeat with i = 2 to the number of elements of tJournalsA+1
         put tJournalsA[i]["Journal_root"] & tab \
               & tJournalsA[i]["abbreviation_FLM"] & return \
               after sJournals
   end repeat
   put empty into char -1 of sJournals
end _import_journals

on    _import_diacritics
   put _get_data_from_Google_Sheet(gGoogleDataSheet, "Diacritics") into tDiacriticsA
   put empty into sDiacritics
   repeat with i = 2 to the number of elements of tDiacriticsA + 1
      put tDiacriticsA[i]["Unicode"] & tab \
            & tDiacriticsA[i]["Prefix"] & tab \
            & tDiacriticsA[i]["Root"] & tab \
            & tDiacriticsA[i]["TeX"] & return \
            after sDiacritics
   end repeat
   put empty into char -1 of sDiacritics
end _import_diacritics
   
   on _style_for_clean_up
   ensure_locked
   put the vscroll of fld "Main text" into my_scroll
   put fld "Main text" into sText
   put remove_confusing_tags(sText) into sText
   put empty into sCleanUpPatterns
   --   _clear_clean_up_data
   put _get_data_from_Google_Sheet(gGoogleDataSheet, "search_patterns") into sPatterns
   put _get_data_from_Google_Sheet(gGoogleDataSheet, "scopes") into sScopes
   _get_pattern_tags
   _get_scope_tags
   repeat with i = 1 to the number of btns of grp "items to clean up"
      if the highlight of btn i of grp "items to clean up" is not true then
         next repeat
      end if
      put the short name of button i of grp "items to clean up" into tItemToClean
      set the cTag of btn tItemToClean of grp "items to clean up" to tTag
      --      get item 3 of sOriginalTextColor
      --      put it + 2 into item 3 of sOriginalTextColor
      --      set the cColor of btn tItemToClean of grp "items to clean up" to sOriginalTextColor
      --      put sOriginalTextColor into sAltColor
      --      get item 2 of sAltColor
      --      put it + 1 into item 2 of sAltColor
      --      set the cAltColor of btn tItemToClean of grp "items to clean up" to sAltColor
      _hightlight_one_item_for_clean tItemToClean
   end repeat
   put "255,0,0" into sOriginalTextColor
   --   put i into tTotalTagged
   _get_clean_up_colors_used
   put _convert_tags_to_html() into tHTML
   set the HTMLText of fld "main text" to tHTML
   set_compact_or_full_view
   set the vscroll of fld "Main text" to my_scroll
   unlock screen
end _style_for_clean_up

on _get_pattern_tags
   put the keys of sPatterns into tKeys
   repeat with i = 1 to the number of lines of tKeys
      put line i of tKeys into tKey
      put sPatternTagA[i] into sPatterns[tKey]["Tag"]
   end repeat
end _get_pattern_tags

on _get_scope_tags
   put the keys of sScopes into tKeys
   repeat with i = 1 to the number of lines of tKeys
      put line i of tKeys into tKey
      put sScopeTagA[i] into sScopes[tKey]["Tag"]
   end repeat
end _get_scope_tags

on set_compact_or_full_view
   if the label of btn "View" is "Full view" then
      show_full_text

   else
      show_compact_text
   end if
end set_compact_or_full_view

   on _clear_clean_up_data
   repeat with i = 1 to the number of btns of grp "items to clean up"
      set the cColor of btn i of grp "items to clean up" to empty
      set the cAltColor of btn i of grp "items to clean up" to empty
      set the cTag of btn i of grp "items to clean up" to empty
   end repeat
end _clear_clean_up_data

on _get_clean_up_colors_used
   put empty into sCleanUpColors
   repeat with i = 1 to the number of btns of grp "items to clean up"
      put the cColor of btn i of grp "items to clean up" & return after sCleanUpColors
      put the cAltColor of btn i of grp "items to clean up" & return after sCleanUpColors
   end repeat
end _get_clean_up_colors_used

on _hightlight_one_item_for_clean pItemToClean
   put sPatterns[pItemToClean]["Search"] into pToHighlight
   put sPatterns[pItemToClean]["Tag"] into tPatternTag
   put sPatterns[pItemToClean]["Scope"] into sCurrentScope
   _tag_scope
   --   _convert_scope_to_html
   _highlight_in_current_scope pToHighlight, tPatternTag
end _hightlight_one_item_for_clean

on _highlight_in_current_scope pToHighlight, pPatternTag
   put the millisecs into ms
   set the itemdelimiter to return
   split pToHighlight by return
   set the linedelimiter to sCurrentScopeTag
   put sStarTag & pPatternTag into tBeginTag
   put pPatternTag & sStarTag into tEndTag
   put empty into tResult
   repeat for each line L in sText
      put L into tLine
      if char 1 of tLine is not sStarTag \
            AND char -1 of tLine is not sStarTag then
         repeat with i = 1 to the number of elements of pToHighlight
            put "(" & pToHighlight[i] & ")"  into tSearch
            put tBeginTag & "\1" & tEndTag into tReplace
            get sunnYreplace(tLine, tSearch, tReplace, tLine)
         end repeat
      end if
      put tLine & the linedelimiter after tResult
      put tResult into sText
   end repeat
   --   _put_space_comma_etc_outside_tag pItemToClean
   --   _put_in_tag_for_tweak pItemToClean
   --   _put_in_tags_for_line_breaks pItemToClean
   --   answer the millisecs -ms
end _highlight_in_current_scope

on _convert_scope_to_html
   put sScopes[sCurrentScope]["textcolor"] into sCurrentScopeColor
   put convert_to_hex(sCurrentScopeColor) into sCurrentScopeColor
   _close_hanging_scope_tags
   put "<font color=" & quote & sCurrentScopeColor & quote & ">" \
         into tHTMLBeginTag
   put "</font>" into tHTMLEndTag
   replace sScopeBeginTag with tHTMLBeginTag in sText
   replace sScopeEndTag with tHTMLEndTag in sText
   put p_tags_insert(sText) into sText
   set the HTMLText of fld "main text" to sText
end _convert_scope_to_html

on _close_hanging_scope_tags

end _close_hanging_scope_tags

on _tag_scope
   put sScopes[sCurrentScope]["Tag"] into sCurrentScopeTag
   put sScopes[sCurrentScope]["Search"] into tSearchLines
   put sStarTag & sCurrentScopeTag into sScopeBeginTag
   put sCurrentScopeTag & sStarTag into sScopeEndTag
   repeat for each line L in tSearchLines
      put "(" & L & ")" into pSearch
      put sScopeBeginTag & "\1" & sScopeEndTag into tReplace
      get sunnYreplace(sText, pSearch, tReplace, sText)
   end repeat
end _tag_scope

   function _convert_tags_to_html
   put remove_confusing_tags(sText) into sText
   repeat with i = 1 to the number of btns of grp "items to clean up"
      put the short name of btn i of grp "items to clean up" into tItemToClean
      if the highlight of btn tItemToClean of grp "items to clean up" is false then
         next repeat
      end if
      put the cTag of btn tItemToClean into tTag
      put tTag & sStarTag into tBeginTag
      put sStarTag & tTag into tEndTag
      put tBeginTag & sWhiteStar into tAltBeginTag
      put sWhiteStar & tEndTag into tAltEndTag
      put the cColor of btn tItemToClean into tColor
      put the cAltColor of btn tItemToClean into tAltColor
      put convert_to_hex(tColor) into tColor
      put convert_to_hex(tAltColor) into tAltColor
      put "<b>" & \
            "<font color=" & quote & tAltColor & quote & ">" \
            into tAltHTMLBeginTag
      put "<b>" & \
            "<font color=" & quote & tColor & quote & ">" \
            into tHTMLBeginTag
      put "</font></b>" into tHTMLEndTag
      replace tAltBeginTag with tAltHTMLBeginTag in sText
      replace tAltEndTag with tHTMLEndTag in sText
      replace tBeginTag with tHTMLBeginTag in sText
      replace tEndTag with tHTMLEndTag in sText
      --      put _tweak_alternate_colors (pText, sOriginalTextColor) into pText
   end repeat
   put p_tags_insert(sText) into sText
end _convert_tags_to_html



--function _tweak_alternate_colors \
--      pText,  \
--      sOriginalTextColor
--   put sOriginalTextColor into tAlternateColor
--   put the last item of tAlternateColor into tBlue
--   if tBlue is not 255 then
--      put tBlue + 1 into tBlue
--   else
--      put tBlue - 1 into tBlue
--   end if
--   put tBlue into the last item of tAlternateColor
--   put convert_to_hex(sOriginalTextColor) into tOrigHex
--   put convert_to_hex(tAlternateColor) into tAltHex
--   put "(?s)(" & tOrigHex & ".+?)(" & tOrigHex & ")" into tSearch
--   put "\1" & tAltHex into tReplace
--   get sunnYreplace(pText, tSearch, tReplace, tResult)
--   return tResult
--end _tweak_alternate_colors

on _put_in_tags_for_line_breaks pItemToClean
   put the cTag of btn pItemToClean into tTag
   put tTag & sStarTag into tBeginTag
   put sStarTag & tTag into tEndTag
   put "(?s)(" & tBeginTag & "[^★]+?)\n([^★]+?" & tEndTag & ")" into tSearch
   put "\1" & tEndTag & "\n" & tBeginTag & "\2" into tReplace
   put empty into tStart; put empty into tEnd
   put the millisecs into ms
   repeat until matchchunk(sText, tSearch) is false
      get sunnYreplace(sText, tSearch, tReplace, tOut)
      put tOut into sText
   end repeat
   -- put in white star to match
   put sWhiteStar & "([^" & sStarTag & sWhiteStar & "]+?)" & sStarTag into tSearch
   put sWhiteStar & "\1" & sWhiteStar & sStarTag into tReplace
   try
      get sunnYreplace(sText, tSearch, tReplace, sText)
   end try
   put sStarTag & "([^" & sStarTag & sWhiteStar & "]+?)" & sWhiteStar into tSearch
   put sStarTag & sWhiteStar & "\1" & sWhiteStar into tReplace
   try
      get sunnYreplace(sText, tSearch, tReplace, sText)
   end try
end _put_in_tags_for_line_breaks

on _put_space_comma_etc_outside_tag pItemToClean
   put the cTag of btn pItemToClean into tTag
   put tTag & sStarTag into tBeginTag
   put sStarTag & tTag into tEndTag
   put "\s+and\s+" into tToFlip
   put _flip_text(sText, tToFlip, tEndTag) into sText
   put ",\s+" into tToFlip
   put _flip_text(sText, tToFlip, tEndTag) into sText
   put "\s+" into tToFlip
   put _flip_text(sText, tToFlip, tEndTag) into sText
end _put_space_comma_etc_outside_tag

on _put_in_tag_for_tweak pItemToClean
   put the cTag of btn pItemToClean into tTag
   put tTag & sStarTag into tBeginTag
   put sStarTag & tTag into tEndTag
   put "(?s)" & tBeginTag & "(.+?" & tEndTag & ".+?" &  \
         tBeginTag & ")(.+?)" & tEndTag into tSearch
   put tBeginTag & "\1" & sWhiteStar & "\2" & sWhiteStar & tEndTag into tReplace
   try
      get sunnYreplace(sText, tSearch, tReplace, tOut)
   end try
   put tOut into sText
end _put_in_tag_for_tweak

function _flip_text pText pFirst, pSecond
   put "(" & pFirst & ")(" & pSecond & ")" into tSearch
   get sunnYreplace(pText, tSearch, "\2\1", tOut)
   return tOut
end _flip_text

   --   on highlight_for_cleanup \
   --      pTo_highlight \
   --      pTag

   --   put "(" & pTo_highlight & ")" into pSearch
   --   put pTag & "\1" & pTag into tReplace
   --   put sunnYreplace( sText, pSearch, tReplace, tOut)
   --   put tOut into sText
   --   put sText
   --end highlight_for_cleanup

   function mark_all_for_clean_up \
      pText, \
      pSearch, \
      pMarker
   put "(?<!" & pMarker & ")" into tNotBefore
   put "(?!" & pMarker & ")" into tNotAfter
   put tNotBefore &  \
         "(" & pSearch & ")" & \
         tNotAfter \
         into tSearch
   repeat until matchChunk( \
         pText, \
         tSearch, \
         tStart, \
         tEnd \
         ) \
         is not true
      put pMarker into char tEnd of pText
      put pMarker into char tStart of pText
   end repeat
   return pText
end mark_all_for_clean_up

   on clean_citations
   -- [1,4-6,8] > citet{1,4,5,6,8}
   if citation_style is "[1,4-6,8] > citet{1,4,5,6,8}" then
      replace_all_chunks \
            "[\n ~]*\[[0-9,\- ]+\]"             , \
            "^[\n ~]*"                          , \
            "~"
   end if
   -- $^{mathrm{[1,7-9]}}$
   if citation_style is "$^{mathrm{[1,7-9]}}$" then
      replace_all_chunks \
            "[\n ~]*\$\^{\\mathrm{[^$]*\[[^$]*}\$"             , \
            "^[\n ~]*"                          , \ -- put in ~
            "~"
      replace_all_chunks \
            "[\n ~]*\$\^{\\mathrm{[^$]*\[[^$]*}\$"             , \
            "\\thinspace *"                          , \ -- remove \thinspace
            " "
      replace_all_chunks \
            "\$\^{\\mathrm{[^$\[]*\[[^$]*}\$"             , \
            "\n"                          , \ -- remove single return in string
            ""
   end if
   if citation_style is "(1, 3-8)" then

   end if
   unlock screen
end clean_citations

on highlight_text
   --   put the vscroll of fld "Main text" into my_scroll
   --   put the selectedChunk of fld "Main text" into my_chunk
   --   put word 2 of my_chunk into select_from
   --   put word 4 of my_chunk into select_to
   lock screen
   remove_all_styles
   --   highlight according to buttons checked
   put the number of chars of fld "Main text" into total_chars
   set the textcolor of char 1 to total_chars of \
         fld "Main text" to empty -- first remove all styles
   put empty into to_highlight
   repeat with i = 1 to the number of btns of group "To highlight"
      if the highlight of btn i of group "To highlight" is true then
         put the short name of btn i of group "To highlight" into to_highlight
         switch to_highlight
            case "Citations"
               highlight_citations
               break
            case "Headings"
               highlight_headings
               break
         end switch
      end if
   end repeat
   show_full_text
   if the_view is "compact_text" then
      show_compact_text
   end if
   --   set the vscroll of fld "Main text" to my_scroll -- not working right
   --   select char select_from to select_to of fld "Main text"
   unlock screen
end highlight_text

on highlight_citations
   put "citations" into highlight_group
   put citation_style
   if citation_style is "[1,4-6,8] > citet{1,4,5,6,8}" then
      highlight_me \
            "\[[0-9, \-]+\]"  , \
            "original"
   end if
   if citation_style is "$^{mathrm{[1,7-9]}}$" then
      highlight_me \
            "\$\^{\\mathrm{[^$\[]*\[[^$]*}\$" , \
            "original"
   end if
   highlight_me \
         "~\\cite{[^}]+}" , \
         "replace"
end highlight_citations

on highlight_me \
     to_highlight \
     orig_or_replace -- is string before or after clean-up?
  put 1 into fromChar
  put the number of chars of fld "Main text" into totalChars
  put "(" & to_highlight & ")" into to_highlight
  repeat
     get matchChunk( \
           char fromChar to totalChars of fld "Main text",  \ -- search from end of last search
           to_highlight, \
           chunkStart, \
           chunkEnd \
           )
     if it is false then exit highlight_me -- no more matches
     put chunkStart + fromChar -1 into ChunkStart
     put chunkEnd + fromChar -1 into ChunkEnd
     if orig_or_replace is "original" then -- before replacing text
        set the backgroundcolor of char chunkStart to chunkEnd of fld "Main text"  \
              to original_bg_color
     else
        set the backgroundcolor of char chunkStart to chunkEnd of fld "Main text"  \
              to replace_bg_color
     end if
     if highlight_group is "Citations" then
        set the textcolor of char chunkStart to chunkEnd of fld "Main text" \
              to citation_text_color
        set the textstyle of char chunkStart to chunkEnd of fld "Main text" \
              to citation_text_style
     end if
     if highlight_group is "Headings" then
        set the textcolor of char chunkStart to chunkEnd of fld "Main text" \
              to heading_text_color
        set the textstyle of char chunkStart to chunkEnd of fld "Main text" \
              to heading_text_style
     end if
     put chunkEnd into fromChar
  end repeat
end highlight_me


on replace_all_chunks \
      pToExtract,  \ -- grab from file
      pToSearch,  \ -- search for this string
      pToReplace -- replace with this
   set the cFromChar of fld "Main text" to 1
   put the number of chars of fld "Main text" into tTotalChars
   repeat
      put "(" & pToExtract & ")" into pToExtract
      put the cFromChar of fld "Main text" into tFromChar
      get matchChunk( \
            char tFromChar to -1 of fld "Main text",  \ -- search from end of last search
            pToExtract, \
            tChunkStart, \
            tChunkEnd \
            )
      if it is false then exit replace_all_chunks -- no more matches
      put tChunkStart + tFromChar -1 into tChunkStart
      put tChunkEnd + tFromChar -1 into tChunkEnd
      set the backgroundcolor of char tChunkStart to tChunkEnd of fld "Main text" to 255,255,0
      put char tChunkStart to tChunkEnd of fld "Main text" into tOriginalText
      put replacetext( \
            tOriginalText, \
            pToSearch, \
            pToReplace \
            ) \
            into tCleanText
      put tCleanText into char tChunkStart to tChunkEnd of fld "Main text"
      set the cFromChar of fld "Main text" to tChunkEnd
   end repeat
end replace_all_chunks

on returnInField
   if the short name of the target is "Main text" or \
         the short name of the target is "replacement" then
      if the visible of fld "replacement" is true then
         write_undo_file
         put the number of chars of fld "replacement" into the_length
         put word 2 of now_selected into aa
         put word 4 of now_selected into bb
         put the textcolor of char aa to bb of fld "Main text" into my_color
         put fld "replacement" into char aa to bb of fld "Main text"
         --         put char aa to \
         --               aa + the_length-1 of fld "Main text"  \
         put aa + the_length-1 into gEnd
         switch my_color
            case citation_text_color -- selection is citation
               set the textstyle of char aa to \
                     gEnd of fld "Main text"  \
                     to citation_text_style
               set the textcolor of char aa to \
                     gEnd of fld "Main text" to \
                     citation_text_color
               set the backgroundcolor of char aa to \
                     gEnd of fld "Main text" to \
                     replace_bg_color
               hide fld "replacement"
         end switch
         write_undo_file
         select_next_chunk gEnd -- only search from end of last replacement
         show_replacement
      end if
   end if
   pass returnInField
end returnInField

on _refresh_structuring_group
   set the cScroll of fld "Structured" to the vscroll of fld "Structured"
   switch the cNowProcessing of group "Structuring"
      case "References"
         structure_all_refs
         break
      case "Prelims"
         structure_prelims
         break
   end switch
   set the vscroll of fld "Structured" to the cScroll of fld "Structured"
end _refresh_structuring_group

on openField
   --put the long name of the target into gActiveField
end openField

function _convert_UPPER_surname_to_lower pText
   put _convert_UPPER_word_to_lower(ptext) into pText
   repeat with i = 2 to the number of chars of pText
      if char i-1 of pText is "-"  then
         put toUpper(char i of pText) into char I of pText
      end if
   end repeat
   put _correct_surname_for_exceptions(pText) into pText
   return pText
end _convert_UPPER_surname_to_lower

function _convert_UPPER_word_to_lower pText
   put toLower(pText) into pText
   put empty into tStart; put empty into tEnd
   put toUpper(char 1 of pText) into char 1 of pText
   repeat with i = 2 to the number of chars of pText
      if char i-1 of pText is space then
         put toUpper(char i of pText) into char I of pText
      end if
   end repeat
   return pText
end _convert_UPPER_word_to_lower

   function _correct_surname_for_exceptions pText
   -- Page with list of exception names:
   -- http://answers.google.com/answers/threadview/id/711284.html
   --
   -- correct prefixes e.g. "de la"
put sPrefixes into tPrefixes
   repeat for each line L in tPrefixes
      put "(?i)^(" & L & " )" into tSearch
      put replacetext(pText, tSearch, L & space) into pText
   end repeat
   -- correct for "O'Neil" etc
   If char 1 to 2  of pText is "O'" then
      put toUpper(char 3 of pText) into char 3 of pText
   end if
   -- McIntosh etc
   If char 1 to 2 of pText is "Mc" then
      put toUpper(char 3 of pText) into char 3 of pText
   end if
   -- MacMillan etc
   put fld "Surnames: Mac" of stack "settings" into tMac
   repeat for each line L in tMac
      if pText is L then
         put L into pText -- corrected case
      end if
   end repeat
   return pText
end _correct_surname_for_exceptions


on keyup tKey
   if chartonum(tKey) = 32 then
      -- space for keyboard shortcuts
      ensure_locked
      lock messages
      repeat with i = 1 to the number of lines of sExpansions
         if line i of sExpansionKey = sTypedText then
            put word 4 of the selectedChunk of gActiveField into tSelection
            put the length of sTypedText into tLength
            put (tSelection - tLength) into tStart
            put line i of sExpansion into \
                  char tStart to tSelection of gActiveField
         end if
      end repeat
      unlock screen
      put empty into sTypedText
   else
      put tKey after sTypedText
   end if
   pass keyUp
end keyup

