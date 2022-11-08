---
title: Description
parent: 'Project: Website for security analysis'
nav_order: 1
---

## Description

The website that we will be implemeting has a landing page similar to the one of *virustotal*.
It offers the possibility to upload a file or a post link.
The input will then be checked from a security perspective and a result will be presented (whether the website or file is malicious or not).
Alternatively, the database can be queried if it contains information regarding a file or a URL.

The website is comprised of 3 major components:

- **The frontend** which is essentially the user facing interface, the actual website.
When a specific action is taken (for example, a button is pressed), the frontend intercepts the action and sends a request to the middleware.
- **The middleware** receives raw requests from the frontend and transforms them into calls to functions that are implemented in the backend.
- **The backend** does the actual heavy lifting in terms of implementing the logic: it stores information in a database and computes whatever values are requested.

Each of the above components will have to be implemented for each of the 3 milestones of the projects.
Essentially, each component represents an assignment.
