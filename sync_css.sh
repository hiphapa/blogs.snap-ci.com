#!/bin/sh

WEBSITE_DIRECTORY=../website.snap-ci.com

cp    $WEBSITE_DIRECTORY/source/assets/stylesheets/_layout.css.scss _assets/stylesheets/layout.scss

cp -r $WEBSITE_DIRECTORY/source/assets/stylesheets/base/* _assets/stylesheets/base