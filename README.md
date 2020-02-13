#  Thread Demo app

This is a fairly simple app that I wrote to try out SwiftUI and Combine, and also trying to think how to architect an app with these new technologies.
To describe it quickly I'd say it's more or less a Redux/TEA code, though due to the limited presence of user-actionable events this is not very visible.

## TODO:
- Improve accessibility: Voice Over should mostly be ok, probably the cells have to be worked on. There probably isn't much else to do on the rest
- Localization: it's absent
- Analytics: it's absent, thankfully
- Improve tests: not everything is covered, and especially the tests that touch `Combine` stuff don't seem ideal. The utilities around it seem to work but are too prone to programming errors
- Improve documentation: there is a fair amount of docs, but they could be more detailed. Especially some documentation describing the general choices of how some layers are managed in the code
- iPadOS: add support
- Solve actual TODOs in code
- Animations: they should be automatically managed by SwiftUI but they don't seem to work at the moment
