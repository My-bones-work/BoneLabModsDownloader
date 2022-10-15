# BoneLabModsDownloader

A simple PowerShell script to automatically download all the mods you subscribed to on mod.io.

## Usage

1. Log in to https://mod.io
2. Go to "My account"
3. On the left side of the screen, click on `🔑 ACCESS`
4. Generate API access and OAuth access keys if you don't have them yet (you'll also have to first accept the terms and conditions)
5. Generate an OAuth access *token*. The token should have read access. You can choose what you want to name it.
6. Download the `Download_mods.ps1` file and place it in a folder where you want downloaded zips of mods to appear
7. Edit the `Download_mods.ps1` file and replace the placeholder token with the OAuth access *token* (**not** the *key*) which you just generated. It should be of similar length to the placeholder value.
8. Save the file, then right-click on it and select "Run with PowerShell".

A window should now pop up where it'll tell you how many subscriptions it found and it should start downloading and unpacking all the zip files.

If it fails to start, then open internet explorer and select an option on the Microsoft SmartScreen popup that you'll probably get. The `Invoke-WebRequest` command that this script heavily relies on internally uses Internet Explorer under the hood so if you haven't accepted or rejected the SmartScreen thing then it'll refuse to do anything.

## Planned features

 * Comparing dates and/or checksums to update installed mods if a newer version is available (now it only downloads any that it doesn't find the .zip of)
 * Adding a platform filter so it only downloads the files relevant for your platform (now it just downloads everything)
 * Quest support (I think that in theory it's as simple as just changing the target path, but I need to do more research and find out a way to test it)
