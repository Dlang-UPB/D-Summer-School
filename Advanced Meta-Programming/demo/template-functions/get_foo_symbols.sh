#! /bin/bash

nm template_functions | grep foo | cut -d ' ' -f 3
