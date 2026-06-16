on run {input, parameters}
	
	-- Ask for new shoot date
	display dialog "Enter new shoot date (YYMMDD):" default answer ""
	set newDate to text returned of result
	
	-- Validate date
	if length of newDate is not 6 then
		display alert "Date must be 6 digits (YYMMDD)."
		return input
	end if
	
	try
		newDate as integer
	on error
		display alert "Date must contain only digits."
		return input
	end try
	
	-- Get selected parent folder
	set parentFolderAlias to item 1 of input
	
	tell application "Finder"
		set folderItems to every folder of parentFolderAlias
	end tell
	
	--------------------------------------------------
	-- PASS 1: FIND THE LATEST DATE
	--------------------------------------------------
	
	set latestDate to 0
	
	repeat with f in folderItems
		
		tell application "Finder"
			set folderName to name of f
		end tell
		
		set parsedData to my parseFolderName(folderName)
		
		if parsedData is not missing value then
			set folderDate to (item 2 of parsedData) as integer
			
			if folderDate > latestDate then
				set latestDate to folderDate
			end if
		end if
		
	end repeat
	
	if latestDate = 0 then
		display alert "No matching folders found."
		return input
	end if
	
	--------------------------------------------------
	-- PASS 2: FIND HIGHEST SEQUENCE PER LETTER
	-- FOR THE LATEST DATE ONLY
	--------------------------------------------------
	
	set suffixLetters to {}
	set suffixVersions to {}
	set suffixPrefixes to {}
	
	repeat with f in folderItems
		
		tell application "Finder"
			set folderName to name of f
		end tell
		
		set parsedData to my parseFolderName(folderName)
		
		if parsedData is not missing value then
			
			set prefixText to item 1 of parsedData
			set folderDate to (item 2 of parsedData) as integer
			set suffixLetter to item 3 of parsedData
			set versionNum to item 4 of parsedData
			
			if folderDate = latestDate then
				
				set idx to my indexOfItem(suffixLetter, suffixLetters)
				
				if idx = 0 then
					set end of suffixLetters to suffixLetter
					set end of suffixVersions to versionNum
					set end of suffixPrefixes to prefixText
				else
					if versionNum > item idx of suffixVersions then
						set item idx of suffixVersions to versionNum
						set item idx of suffixPrefixes to prefixText
					end if
				end if
				
			end if
			
		end if
		
	end repeat
	
	if (count of suffixLetters) = 0 then
		display alert "No folders found for latest date."
		return input
	end if
	
	--------------------------------------------------
	-- BUILD LIST OF NEW FOLDERS
	--------------------------------------------------
	
	set foldersToCreate to {}
	set confirmText to "Create these folders:" & return & return
	
	repeat with i from 1 to count of suffixLetters
		
		set prefixText to item i of suffixPrefixes
		set suffixLetter to item i of suffixLetters
		
		set nextVersion to (item i of suffixVersions) + 1
		
		set versionText to ("00" & nextVersion)
		set versionText to text ((length of versionText) - 2) thru -1 of versionText
		
		set newFolderName to prefixText & newDate & "_" & suffixLetter & versionText
		
		set end of foldersToCreate to newFolderName
		
		set confirmText to confirmText & newFolderName & return
		
	end repeat
	
	display dialog confirmText buttons {"Cancel", "Create"} default button "Create"
	
	--------------------------------------------------
	-- CREATE FOLDERS
	--------------------------------------------------
	
	tell application "Finder"
		
		repeat with newFolderName in foldersToCreate
			
			if not (exists folder (contents of newFolderName) of parentFolderAlias) then
				make new folder at parentFolderAlias with properties {name:(contents of newFolderName)}
			end if
			
		end repeat
		
	end tell
	
	return input
	
end run


on parseFolderName(folderName)
	
	-- Expected pattern:
	-- PREFIX + YYMMDD + "_" + LETTER + ###

	if (length of folderName) < 11 then return missing value
	
	try
		
		set suffixLetter to character ((length of folderName) - 3) of folderName
		
		set versionText to text ((length of folderName) - 2) thru (length of folderName) of folderName
		set versionNum to versionText as integer
		
		set dateStartPos to (length of folderName) - 10
		
		set dateText to text dateStartPos thru (dateStartPos + 5) of folderName
		
		dateText as integer -- validate date
		
		if dateStartPos > 1 then
			set prefixText to text 1 thru (dateStartPos - 1) of folderName
		else
			set prefixText to ""
		end if
		
		return {prefixText, dateText, suffixLetter, versionNum}
		
	on error
		return missing value
	end try
	
end parseFolderName


on indexOfItem(theItem, theList)
	
	repeat with i from 1 to count of theList
		if item i of theList = theItem then return i
	end repeat
	
	return 0
	
end indexOfItem
