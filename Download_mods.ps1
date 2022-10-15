# Replace this placeholder token with your OAuth access token, it should have a similar length as this one. Make sure to leave the single quotes at the start and end in place.
$token='qFSDqfsgDSGsergfsdgshNotARealAccessTokenqsdfhiqsfUseYourOwnTokendqsihfqsdfSDFqgfsdfgsfdogqdfGSDGsdgksdfpgkSDFGJOQJFGsqdfgojsqdfgqoigjisodfhgioqhlgerioqghfuilshqfgfQDFGJOQJgdfqgfdGKQSDgQdsFGqrgqsfdgsdfgQgNoEasterEggsHereqsdfQSdfqsfSDfqsfqsdFFSDQFDqsfdsqfrEHYrujhTFGJHFjhfGjRFyjRdyzTryztRYegsgZrtheRjeyjyedythzsgfSdgzsHtEytdrhjdJHUrkiTkDhgfEDhtzstRhzsytRYtreHyehdHDgheRTYteSyhsehrtyjzeutzutztyERygfdYGzrtyTerUyteuytetyztytrzYZyTeRTYeuhUJEDZTryzrUjuytkRFHGJDFTYEtyeuyeuytYesITypedThisWholeThingManuallysdfgsdfgsdgFSDGsfdgqFGQSDgsdfGSHSDFghsdHBSDBHShsEQgFSdgSDFGsdgsdfGSdhfgdhshtrsssssssssssshgdhSDFGsfdgresqgfggggggggggggggggggggggggdfffffffffffffffffffffffffffffffgggggggggggggggggggggoijioojqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqoooooooooo^prgjkiajraeioufn,aoutfoiparfopa,tfuaop,f,atpod,ap,ifauipofnc,upaiozeruoifanuzerpuicfnnapioprjioopaoioiodfsqjjfdlkqklklflkqlfllBcHMsqgfsdgfsdHSGFHsdqsfdhqAZERTYUOPMLKHGHFDGHSHGSHTRStrdhgsghsdhugkfdhhqghreqguihsergquigiiuiiuuiqlllllllsfldgoe8627v68st7h2sr3t27gv3s5gf2v4s3g428er4qb27s3ytr1v38zq1v83sf4g5v3sfdg1er8s1v5fsd34gs365fg4sr89e4g3f65g4s3r8e4gfsDamnThisThingIsLong...qfsdgoihsdfuighuisghyfuqkyfuegzgfqskfdqhfdhgqfhdqskfejhiqzulfhiqlzghqlfjdqs<ilhgqergjhqsregioqsergldsqfjqozeihfqlihgaqmrighliqsehgruseiqhguilqhaghrulqhgliuqergsh54gsdf364hgfdj364sg36h436h4s5th3g54sgsquefgyqufgyquefgakfguyqfuioqqpgjnqoueizhfrqzobrgqogqogfqsilghquisfgquilrgoqigdbqfuipqgbfiiqepgqighprqeghqeigpqseguipqibguiqpbbgiufqbhrlgfhqsdjfhqsfgjsbghjbsqdfhgbsdfjbgfdsgfdgfFinallyAlmostDonedhfjshfjdhfjsfhghdsfghrsejDPUG7csdfgFgz'

# This is the default BONELAB mod folder location, change this if you moved your mods folder or want to send the decompressed files to another folder.
$destination="$env:appdata\..\LocalLow\Stress Level Zero\BONELAB\Mods"


# The rest of the script follows below, but you shouldn't have to adjust any parameters there.




Echo "Checking subscriptions..."
# Request the list of subscriptions this account has for BONELAB (game id 3809)
$sublist_json=Invoke-WebRequest -URI https://api.mod.io/v1/me/subscribed?game_id=3809 -Method GET -Headers @{"Authorization"="Bearer ${token}";"Accept"="application/json"}
$sublist=ConvertFrom-Json $sublist_json.Content

$len=$sublist.data.length
[string]$len_str=$len
Echo "Found $len_str subscription(s)."

# Iterate over the list of subscriptions
for ($i = 0; $i -lt $len; $i++)
{
  # Request a list of files that this mod has
	$sub=$sublist.data[$i]
	$subname=$sub.name
	Echo "Requesting info about subscription $subname..."
	[string]$modid=$sub.id
	$mod_json=Invoke-WebRequest -URI https://api.mod.io/v1/games/3809/mods/${modid}/files -Method GET -Headers @{"Authorization"="Bearer ${token}";"Accept"="application/json"}
	$mod=ConvertFrom-Json $mod_json.Content

	$datalen=$mod.data.length
	[string]$datalen_str=$datalen
	Echo "$subname contains $datalen_str file(s)."
	
  # Iterate over that list of files
	for ($j = 0; $j -lt $datalen; $j++)
	{
		$data=$mod.data[$j]
		$file=$data.filename
    
    # If no file with the same name exists locally, download the mod
		if (-not(Test-Path $file))
		{
			Echo "  Downloading $file..."
			$url=$data.download.binary_url
			Invoke-WebRequest -URI $url -OutFile $file
			Echo "  Unpacking $file..."
			Expand-Archive $file -DestinationPath $destination -Force
		}
		else
		{
			Echo "  Skipped $file (already exists)."
		}
	}
}

# Make sure the window doesn't immediately close if an error happens
Pause
