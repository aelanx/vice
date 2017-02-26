@echo off

cd "%~dp0"

if not exist bin mkdir bin

python build.py
