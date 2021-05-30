#!/bin/sh
hugo -D && rsync -r --delete public/ server:/var/www/personal_website
