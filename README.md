# Grunty
Birds may tweet across a yard, but when exploring the vast Canadian wilderness, it is the moose that can be heard clearly, grunting one to the other.
Introducing Grunty: A moose-themed twitter clone for the wilds of Canada  ;-)

By Andrew Ash

Please note all messages printed to console are gated by a check to make sure we're not running on production.

## Requirements
- Xcode 12, 13, or 14
- iOS 14, 15, or 16

## What's New
Version 1.2 - Dec 2022
- Resolved a compiler warning introduced by Xcode 13
- Verified app runs free of errors and warnings on Xcode 14 and iOS 16 

Version 1.1 - July 2020
- MVVM architecture
- Added unit tests for view models.  
- Common view controller functionality moved to my new `ErrorReportingViewController` protocol.
- View controllers are cleaner and more consistent

- Dependency injection instead of singletons. `DataStore` can also be mocked with fake models for testing purposes.
- `UIStackView`s used extensively for simpler auto-layout, with fewer constraints to manage, and fewer lines of code.
- `NetworkManager` is more DRY with one `download` method that uses generics, and the actual REST API endpoint URLs are provided by types which conform to my new `RemoteURLProviding` protocol. 
- Network requests have shorter timeouts for when the Heroku REST API service is unreliable
- Consistently thorough comments and documentation
- I only use `self` in initializers and to disambiguate between a local variable and class member with the same name.
- More succint 1-line computed properties that omit `return`
- All error messages are passed up the stack, and all helpful information is shown to the user in an error dialog. For security reasons, in a production app I'd submit this to a monitoring service instead of showing some of these details to the user. 
- `DataStore` now retrieves models from memory, falling back to on-disk storage, and lastly to requesting from the network. You can see this work by viewing debug messags in the console. Refactored to be more DRY by moving common code into a `retrieve` method that takes a type parameter `T` (via generics). My goal was as simple as possible but no simpler.

## Original Design
Version 1.0 - June 2020
- Uses some newer Swift features like the Result type
- Comments load async when you tap to view a post and appear in a nested UITableView
- The Codable protocol on my model classes to encode/decode JSON
- In-memory and disk caching for faster launch times, via the Codable protocol and FileManager to save and load from the disk
- Unit testing to verify that the models and NetworkManager work as expected.
- Offline support. You can launch the app offline on first run, which fails with an error. When you connect to the Internet it works.
- Adds a Refresh button at top-right to retrieve the latest grunts instead of cached grunts
- All artwork is licensed from Shutterstock

## Known Issues
None
