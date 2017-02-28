#!/bin/bash

FILE=Vyrl/DOMAIN.swift

echo $BUDDYBUILD_BRANCH
if [ $BUDDYBUILD_BRANCH = "master" ]; then
  echo "This should set whatever env variable for app to be against prod API environment"
else
  echo "This should set whatever env variable for app to be against dev API environment"
fi
