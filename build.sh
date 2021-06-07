#!/usr/bin/env bash

source env.sh

image=microsys-image-auto

exec bitbake "$image"
