#!/bin/bash

ps aux --sort -rss | sed -n 2p >> ~/memusage.txt
