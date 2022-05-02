#!/bin/sh
hugo -D && rsync -ra --delete public/ server:/var/www/personal_website
