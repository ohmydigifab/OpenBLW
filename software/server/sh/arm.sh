#!/bin/bash

echo 0=1000us > /dev/servoblaster
echo 1=1500us > /dev/servoblaster
echo 5=1500us > /dev/servoblaster
echo 6=1500us > /dev/servoblaster
echo 7=2000us > /dev/servoblaster

echo 6=1000us > /dev/servoblaster
sleep 1
echo 6=1500us > /dev/servoblaster