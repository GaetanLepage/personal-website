#!/bin/sh
hugo -D && rsync -rv --delete public/ server:/var/www/personal_website
