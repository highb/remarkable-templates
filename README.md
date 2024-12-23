# remarkable-templates

My templates and a little script to help manage them on the Remarkable.

## Setup

Run `mise install` with [Mise](https://mise.jdx.dev/). Alternatively, look at
`.tool-versions` and install the specified tools.`

## Usage

Go to `Settings/About/Copyrights and licences` and find the IP address at the bottom.

Then run `./manage.sh` to Backup/Restore/Sync/SSH into the Remarkable using that IP.

## Making templates

Go to [Noteto](https://noteto.needleinthehay.de/) and load an existing template, or make a new one. Note that if you
are updating an existing template, you should save it with a new version, otherwise
old notes are going to look weird because the writing won't necessarily match the
template.

Make the template, save the new JSON and PNG, add it to `add-templates.json`, and then
sync it with `manage.py`.