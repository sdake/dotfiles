#!/usr/bin/env fish

# Set output path for the plist
set plist_path ~/Library/LaunchAgents/environment.plist

# Start the plist content
set plist_content "
<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
  <key>Label</key>
  <string>user.environment</string>
  <key>EnvironmentVariables</key>
  <dict>
"

# Loop over all environment variables and add them to the plist
for var in (env | string split '\n')
    set key_value (string split '=' $var)
    if test (count $key_value) -eq 2
        set key $key_value[1]
        set value $key_value[2]

        # Avoid exporting sensitive or redundant variables
        if string match -q "*PATH*" $key
            set plist_content "$plist_content    <key>$key</key>\n    <string>$value</string>\n"
        end
    end
end

# Close the plist content
set plist_content "$plist_content  </dict>\n</dict>\n</plist>"

# Write the plist to the file
echo $plist_content > $plist_path

## Load the plist
# launchctl unload $plist_path ^/dev/null
# launchctl load $plist_path

echo "Plist generated at $plist_path and loaded into launchctl"

