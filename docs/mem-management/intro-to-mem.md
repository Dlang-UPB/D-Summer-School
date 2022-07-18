---
nav_order: 7
title: Memory Management
has_children: true
---
# Memory Management

During this lab you will learn about general memory management concepts and how they relate to specific implementations in D and other widely-used programming languages.

# Motivation

Before diving into memory management, let's understand the motivation for having a memory management system in a modern programming language.

# Properties of program entities

The entities that live in our programs (basic types, arrays or aggregate types like structs and classes) have a few properties:
- name (used to identify the variable)
- address (location in program memory)
- type (depending on the language, it can be inferred or must be declared explicitly)
You should already be familiar with those.

When talking about memory management, two (less talked about) properties are of interest: scope and lifetime.
