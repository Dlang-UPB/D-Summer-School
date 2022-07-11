---
title: Logging
parent: Advanced Meta-Programming
nav_order: 1
---
# Logging

In large applications, logs are a very useful tool for debugging.
In addition, they provide a huge help for newcomers, allowing them to understand the inner working of the project faster.
Thirdly, logs are extremely valuable for security.
Because they provide information about the behaviour of an application, security engineers monitor them to detect malware, while hackers try to tamper with logs to cover their tracks.

In this session, you'll implement a simple logger.
Typically, logs must contain relevant information about their source such as:
- **When:** The timestamp of the logged event
- **Who:** The application or user name
- **Where:** The context of the event: module, file, line number etc.
- **What:** The type of activity (login error, I/O error etc.) and error category (info, debug, warning, error etc.)

To make our logger easier to `unittest`, we will skip the "volatile" attributes of logs, such as timestamp and line number.
Concretely, our logger will display a given message, together with the log level and file name.
Our goal today is to implement this logger by leveraging D's flexibility and strength in metaprogramming.
