#!/bin/bash

if [[ -z $(which gum) ]]; then
    echo "gum not installed. Run mise install"
    exit 1
fi

set -e

TEMPLATES_DIR="/usr/share/remarkable/templates"
REMARKABLE_IP=$(gum input --value "10.0.40.109" --placeholder "Remarkable IP")
REMARKABLE_USERHOST="root@${REMARKABLE_IP}"
TASK=$(gum choose "backup" "restore" "sync" "ssh")

if [[ "${TASK}" = "sync" ]]; then
    echo "Syncing template images to ${REMARKABLE_USERHOST}"
    scp noteto-*.png "${REMARKABLE_USERHOST}":"${TEMPLATES_DIR}"
    echo "Copying remarkable templates.json to workdir/templates.json"
    scp "${REMARKABLE_USERHOST}":"${TEMPLATES_DIR}"/templates.json workdir/templates.json
    echo "Merging repo templates into workdir/templates.json.tmp"
    # Merge .templates keys from repo into remarkable templates.json from add-templates.json
    python merge.py workdir/templates.json add-templates.json workdir/templates.json.tmp
    echo "Copying workdir/templates.json.tmp to remarkable"
    scp *.png "${REMARKABLE_USERHOST}":"${TEMPLATES_DIR}"
    scp workdir/templates.json.tmp "${REMARKABLE_USERHOST}":"${TEMPLATES_DIR}"/templates.json
    echo "Templates synced"
elif [[ "${TASK}" = "backup" ]]; then
    echo "Backing up templates from ${REMARKABLE_USERHOST}"
    scp "${REMARKABLE_USERHOST}":"${TEMPLATES_DIR}"/templates.json backup/templates.json
    scp "${REMARKABLE_USERHOST}":"${TEMPLATES_DIR}"/*.png backup/
    scp "${REMARKABLE_USERHOST}":"${TEMPLATES_DIR}"/*.svg backup/
    echo "Templates backed up"
elif [[ "${TASK}" = "restore" ]]; then
    echo "Restoring templates to ${REMARKABLE_USERHOST}"
    scp backup/templates.json "${REMARKABLE_USERHOST}":"${TEMPLATES_DIR}"/templates.json
    scp backup/*.png "${REMARKABLE_USERHOST}":"${TEMPLATES_DIR}"
    scp backup/*.svg "${REMARKABLE_USERHOST}":"${TEMPLATES_DIR}"
    echo "Templates restored"
elif [[ "${TASK}" = "ssh" ]]; then
    echo "Remember: Templates are in ${TEMPLATES_DIR}"
    ssh "${REMARKABLE_USERHOST}"
fi
