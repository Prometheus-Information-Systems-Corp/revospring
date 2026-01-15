# Contributing

Thank you for reading this! This document has some notes on contributing to the
development of Revospring.

## Reporting issues

Before reporting a new issue, please check our GitLab issues to see if it
already exists. If it does, please add any additional details you have or give
it a 👍 reaction.

If you don’t see an existing issue, please email us at support@revospring.net.
You can send bug reports, feature requests, questions, or anything else you
think we should see. We’ll review it and create or update a GitLab issue as we
see fit.

When reporting an issue, please describe it clearly, including how to reproduce
it, which situations it appears in, what you expect to happen, what actually
happens, and what platform (browser and operating system) you are using. We
find screenshots (for front-end issues) very helpful.

## Development workflow

1. Sign up on our GitLab (you’re reading this there).
2. Join our Discord server and post in the **development** channel:
   https://discord.gg/QWppNNCuGt  
   Include your GitLab username and the issue you want to work on.
3. New GitLab accounts are blocked by default until we approve them (GitLab
   feature). Once we approve your user, you’re good to go.
4. Fork the repository in GitLab.
5. Create your feature branch (`git checkout -b feature/new`).
6. Commit your changes (`git commit -am 'Add some feature'`).
7. Push to your fork (`git push origin feature/new`).
8. Open a Merge Request targeting the `master` branch.

We love Merge Requests! We are very happy to work with you to get your changes
merged in, however please keep the following in mind.

* Please use the core team standard of `feature/*` or `bugfix/*` branch naming.
  * Using these branch prefixes tags the Merge Requests with the appropriate labels for release categorization.
* Adhere to the coding conventions you see in the surrounding code.
* If you include a new feature also include tests, and make sure they'll pass.
* Before submitting a merge request, clean up the history by going over your
  commits and squashing together minor changes and fixes into the corresponding
  commits. You can do this using the [interactive rebase](https://git-scm.com/book/en/v2/Git-Tools-Rewriting-History#_changing_multiple) command.
