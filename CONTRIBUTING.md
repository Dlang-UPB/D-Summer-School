# Contributing to the D Summer School

These are recommendations when contributing to the contents of the D Summer School repository.
They consider contributions to both actual content (mostly Markdown), support code (tutorials and exercises) and quizzes made via Git.

## First Steps

Some good first steps and best practices when using Git are explained here:
* the Git Immersion tutorial: https://gitimmersion.com/
* the Atlassian tutorial: https://www.atlassian.com/git/tutorials/learn-git-with-bitbucket-cloud
* this blog post on the ROSEdu Techblog: https://techblog.rosedu.org/git-good-practices.html

## Language

All of our content is developed in English.
This means we use English for content, support code, commit messages, pull requests, issues, comments, everything.

## Content Writing Style

This section addresses the development of session content and other Markdown files.

Write each sentence on a new line.
This way, changing one sentence only affects one line in the source code.

Use the **first person plural** when writing documentation and tutorials.
Use phrases like "we run the command / tool", "we look at the source code", "we fix the bug".

Use the second person for challenges and other individual activities.
Use phrases like "compile the code", "implement this function", "write a unittest".

## Images

Use [draw.io](https://app.diagrams.net/) to create diagrams.
If using external images / diagrams, make sure they use a `CC BY-SA` license and give credits (mention author and / or add link to the image source).

## Issues

When opening an issue, please clearly state the problem.
Make sure it's reproducible.
Add images if required.
Also, if relevant, detail the environment you used (OS, software versions: compiler, standard library etc.).
Ideally, if the issue is something you could fix, open a pull request with the fix.

## Discussions

Use GitHub discussions for bringing up ideas on content, new chapters, new sections.
Provide support to others asking questions and take part in suggestions brought by others.
Please be civil when taking part in discussions.

## Pull Requests

For pull requests, please follow the [GitHub flow](https://docs.github.com/en/github/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request-from-a-fork): create a fork of the repository, create your own branch, do commits, push changes to your branch, do a pull request (PR).
The destination branch of pull requests is the default `master` branch.

Make sure each commit corresponds to **one** code / content change only.
If there are multiple commits belonging to a given change, please squash the commits.

Also make sure one pull request covers only **one** topic.

Use commit messages with verbs at imperative mood: "Add README", "Update contents", "Introduce feature".
Prefix each commit message with the session it belongs to: `lab-01`, `lab-06`.
How a good commit message should look like: https://cbea.ms/git-commit/

The use of `-s` / `--signoff` when creating a commit is optional, but strongly recommended.
