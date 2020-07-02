# Grunty
Birds may tweet across a yard, but when exploring the vast Canadian wilderness, it is the moose that can be heard clearly, grunting one to the other.
Introducing Grunty: A moose-themed twitter clone for the wilds of Canada  ;-)

By Andrew Ash

Please note all messages printed to console are gated by a check to make sure we're not running on production.

## Dev Design
- MVVM architecture
- Dependency injection
- Uses some newer Swift features like the Result type
- Comments load async when you tap to view a post and appear in a nested UITableView
- The Codable protocol on my model classes to encode/decode JSON
- In-memory and disk caching for faster launch times, via the Codable protocol and FileManager to save and load from the disk
- Unit testing to verify that the models and NetworkManager work as expected.
- Offline support. You can launch the app offline on first run, which fails with an error. When you connect to the Internet it works.
- Adds a Refresh button at top-right to retrieve the latest grunts instead of cached grunts
- All artwork is licensed from Shutterstock

### Known Issues
None

