#! /usr/bin/env bash
lua5.3 generate_craft_list.lua > craft_list.md
lua5.3 generate_craft_graph.lua | dot.exe -Tsvg -o pictures/crafts.svg
